// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../parameterized_message.dart';

class MethodGeneration {
  final GenerationOptions options;
  final String? context;
  final List<ParameterizedMessage> messages;
  final Map<String, String> emptyFiles;

  MethodGeneration(this.options, this.context, this.messages, this.emptyFiles);

  Method? generateMessageCall(int index, ParameterizedMessage message) {
    if (!message.nameIsDartConform) {
      return null;
    }
    final arguments = message.placeholders
        .map((placeholder) => placeholder.name)
        .join(', ');

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
    final messageCalls = List.generate(
      messages.length,
      (i) => generateMessageCall(i, messages[i]),
    ).whereType<Method>();
    final loadLocale = Method((mb) {
      final selectorName = options.pluralSelector == PluralSelectorType.custom
          ? 'pluralSelector'
          : '_pluralSelector';

      final loading = switch (options.target) {
        TargetEnvironment.flutter => _flutterLoading(selectorName),
        TargetEnvironment.dart => _dartLoading(selectorName),
        TargetEnvironment.manual => _manualLoading(selectorName),
      };

      mb
        ..name = 'loadLocale'
        ..requiredParameters.add(
          Parameter(
            (p0) => p0
              ..name = 'locale'
              ..type = const Reference('String'),
          ),
        )
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
    });
    final loadAllLocales = Method((mb) {
      mb
        ..name = 'loadAllLocales'
        ..returns = const Reference('Future<void>')
        ..modifier = MethodModifier.async
        ..body = const Code('''
          for (final locale in knownLocales) {
             await loadLocale(locale);
          }
      ''');
    });
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

  String _dartLoading(String selectorName) {
    return '''
        String? data;
        ${emptyFiles.entries.map((e) => '''
if (locale == '${e.key}') {
 await ${e.value}.loadLibrary();
 data = ${e.value}.data;
}
''').join(' else ')}
        if (data == null) {
          if (_assetLoader case final assetLoader?) {
            final info = _dataFiles[locale];
            final dataFile = info?.\$1;
            if (dataFile != null) {
              data = await assetLoader(dataFile);
            }
          }
        }
        if (data == null) {
          throw ArgumentError('Locale \$locale is not in \$knownLocales');
        }
        final messageList = MessageListJson.fromString(data, $selectorName);''';
  }

  String _flutterLoading(String selectorName) {
    return '''          final String data;
        if (_assetLoader case final assetLoader?) {
          data = await assetLoader(dataFile);
        } else {
          data = await rootBundle.loadString(dataFile.substring('packages/${options.packageName}/'.length));
        }
        final messageList = MessageListJson.fromString(data, $selectorName);
        ${emptyFiles.entries.map((e) => '''
if (locale == '${e.key}') {
 await ${e.value}.loadLibrary();
}
''').join(' else ')}''';
  }

  String _manualLoading(String selectorName) {
    return '''          final data = await _assetLoader(dataFile);
        final messageList = MessageListJson.fromString(data, $selectorName);
        ${emptyFiles.entries.map((e) => '''
if (locale == '${e.key}') {
 await ${e.value}.loadLibrary();
}
''').join(' else ')}''';
  }
}
