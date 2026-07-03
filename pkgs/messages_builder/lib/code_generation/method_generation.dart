// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../parameterized_message.dart';

class MethodGeneration {
  final DeserializationType deserialization;
  final String? context;
  final List<ParameterizedMessage> messages;

  MethodGeneration(
    this.deserialization,
    this.context,
    this.messages,
  );

  Method? generateMessageCall(int index, ParameterizedMessage message) {
    if (!message.nameIsDartConform) {
      return null;
    }
    final arguments =
        message.placeholders.map((placeholder) => placeholder.name).join(', ');

    final body = '_currentMessages.generateStringAtIndex($index, [$arguments])';
    final methodType = message.placeholders.isEmpty ? MethodType.getter : null;
    return Method(
      (mb) => mb
        ..type = methodType
        ..name = message.name
        ..lambda = true
        ..returns = const Reference('String')
        ..requiredParameters.addAll(
          message.placeholders.map(
            (placeholder) => Parameter(
              (pb) => pb
                ..type = Reference(placeholder.type ?? 'String')
                ..name = placeholder.name,
            ),
          ),
        )
        ..body = Code(body),
    );
  }

  List<Method> generate() {
    Iterable<Method> messageCalls;
    messageCalls = List.generate(
      messages.length,
      (i) => generateMessageCall(i, messages[i]),
    ).whereType<Method>();
    final loadLocale = Method(
      (mb) {
        final loading = switch (deserialization) {
          DeserializationType.web => '''
          final data = await _assetLoader(dataFile);
          final messageList = MessageListJson.fromString(data, _pluralSelector);''',
        };
        mb
          ..name = 'loadLocale'
          ..requiredParameters.add(Parameter(
            (p0) => p0
              ..name = 'locale'
              ..type = const Reference('String'),
          ))
          ..modifier = MethodModifier.async
          ..body = Code('''
          if (!_messages.containsKey(locale)) {
            final info = _dataFiles[locale];
            final dataFile = info?.\$1;
            if (dataFile == null) {
              throw ArgumentError('Locale \$locale is not in \$knownLocales');
            }
            $loading
            if (messageList.preamble.hash != info?.\$2) {
              throw ArgumentError(\'\'\'
              Messages file for locale \$locale has different hash "\${messageList.preamble.hash}" than generated code "\${info?.\$2}".\'\'\');
            }
            _messages[locale] = messageList;
          }
          _currentLocale = locale;
      ''')
          ..returns = const Reference('Future<void>');
      },
    );
    final loadAllLocales = Method(
      (mb) {
        mb
          ..name = 'loadAllLocales'
          ..returns = const Reference('Future<void>')
          ..modifier = MethodModifier.async
          ..body = const Code('''
          for (final locale in knownLocales) {
             await loadLocale(locale);
          }
      ''');
      },
    );
    final getKnownLocales = Method(
      (mb) => mb
        ..name = 'knownLocales'
        ..type = MethodType.getter
        ..lambda = true
        ..static = true
        ..body = const Code('_dataFiles.keys')
        ..returns = const Reference('Iterable<String>'),
    );
    final getCurrentMessages = Method(
      (mb) => mb
        ..name = '_currentMessages'
        ..type = MethodType.getter
        ..lambda = true
        ..body = const Code('_messages[currentLocale]!')
        ..returns = const Reference('MessageList'),
    );
    final getCurrentLocale = Method(
      (mb) => mb
        ..name = 'currentLocale'
        ..type = MethodType.getter
        ..lambda = true
        ..body = const Code('_currentLocale')
        ..returns = const Reference('String'),
    );
    return [
      getCurrentLocale,
      getCurrentMessages,
      getKnownLocales,
      loadLocale,
      loadAllLocales,
      ...messageCalls,
    ];
  }
}
