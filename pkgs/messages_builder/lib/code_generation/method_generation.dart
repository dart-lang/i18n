// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'generation.dart';

class MethodGeneration {
  final GenerationOptions options;
  final String? context;
  final List<MessageWithMetadata> messages;

  MethodGeneration(this.options, this.context, this.messages);

  Method? generateMessageCall(int index, MessageWithMetadata message) {
    if (!message.nameIsDartConform) {
      return null;
    }
    final arguments =
        message.placeholders.map((placeholder) => placeholder.name).join(', ');

    final indexStr = options.indexType == IndexType.enumerate
        ? '${enumName(context)}.${message.name}.index'
        : index.toString();
    final body =
        '_currentMessages.generateStringAtIndex($indexStr, [$arguments])';
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
                ..type = Reference(placeholder.type)
                ..name = placeholder.name,
            ),
          ),
        )
        ..body = Code(body),
    );
  }

  List<Method> generate() {
    Iterable<Method> messageCalls;
    if (options.messageCalls) {
      messageCalls = List.generate(
        messages.length,
        (i) => generateMessageCall(i, messages[i]),
      ).whereType<Method>();
    } else {
      messageCalls = [];
    }
    final loadLocale = Method(
      (mb) {
        final loading = switch (options.deserialization) {
          DeserializationType.web => '''
          final data = await AssetBundle.loadString(carb);
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
            final carb = info?.\$1;
            if (carb == null) {
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
          ..returns = const Reference('void')
          ..body = const Code('''
          for (final locale in knownLocales) {
             loadLocale(locale);
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
    final getMessagebyId = Method((mb) => mb
      ..name = 'getById'
      ..requiredParameters.addAll([
        Parameter(
          (pb) => pb
            ..name = 'id'
            ..type = const Reference('String'),
        )
      ])
      ..optionalParameters.add(Parameter(
        (pb) => pb
          ..name = 'args'
          ..type = const Reference('List<dynamic>')
          ..defaultTo = const Code('const []'),
      ))
      ..body =
          const Code('return _currentMessages.generateStringAtId(id, args);')
      ..returns = const Reference('String'));
    final findByEnum = Method((mb) => mb
      ..name = 'getByEnum'
      ..annotations
          .add(const CodeExpression(Code("pragma('dart2js:noInline')")))
      ..requiredParameters.add(Parameter(
        (pb) => pb
          ..name = 'val'
          ..type = Reference(enumName(context)),
      ))
      ..optionalParameters.add(Parameter(
        (pb) => pb
          ..name = 'args'
          ..type = const Reference('List<dynamic>')
          ..defaultTo = const Code('const []'),
      ))
      ..body =
          const Code('_currentMessages.generateStringAtIndex(val.index, args)')
      ..lambda = true
      ..returns = const Reference('String'));

    return [
      getCurrentLocale,
      getCurrentMessages,
      if (options.findById) getMessagebyId,
      if (options.indexType == IndexType.enumerate) findByEnum,
      getKnownLocales,
      loadLocale,
      loadAllLocales,
      ...messageCalls,
    ];
  }
}
