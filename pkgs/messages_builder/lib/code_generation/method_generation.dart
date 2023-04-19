// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages/message_format.dart';
import 'package:messages_builder/code_generation/generation.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';

class MethodGeneration extends Generation<Method> {
  final GenerationOptions options;
  final String? context;
  final MessageListWithMetadata messageList;
  final Map<String, String> resourceToHash;

  MethodGeneration(
    this.options,
    this.context,
    this.messageList,
    this.resourceToHash,
  );

  Method generateMessageCall(int index, MessageWithMetadata message) {
    var arguments =
        message.placeholders.map((placeholder) => placeholder.name).join(', ');
    var body =
        '_currentMessages.generateStringAtIndex(${indicesName(messageList.context)}.${message.name}, [$arguments])';
    return Method(
      (mb) => mb
        ..name = message.name
        ..lambda = true
        ..returns = Reference('String')
        // ..annotations.add(CodeExpression(Code("pragma('dart2js:noInline')")))
        ..requiredParameters
            .addAll(message.placeholders.map((placeholder) => Parameter(
                  (pb) => pb
                    ..type = Reference(placeholder.type)
                    ..name = placeholder.name,
                )))
        ..body = Code(body),
    );
  }

  Method generateInlinedMessageCall(int index, MessageWithMetadata message) {
    var placeholders =
        message.placeholders.map((placeholder) => placeholder.name);
    var arguments = placeholders.join(', ');

    var msg = message.message;
    String body;
    if (msg is StringMessage) {
      body = msg.generateString(placeholders.map((e) => '\$$e').toList());
    } else if (msg is CombinedMessage) {
    } else if (msg is PluralMessage) {
    } else if (msg is SelectMessage) {
    } else if (msg is GenderMessage) {
    } else {
      throw ArgumentError();
    }
    body =
        '_currentMessages.generateStringAtIndex(${indicesName(messageList.context)}.${message.name}, [$arguments])';
    return Method(
      (mb) => mb
        ..name = message.name
        ..lambda = true
        ..returns = Reference('String')
        // ..annotations.add(CodeExpression(Code("pragma('dart2js:noInline')")))
        ..requiredParameters
            .addAll(message.placeholders.map((placeholder) => Parameter(
                  (pb) => pb
                    ..type = Reference(placeholder.type)
                    ..name = placeholder.name,
                )))
        ..body = Code(body),
    );
  }

  @override
  List<Method> generate() {
    var messages = messageList.messages;
    List<Method> messageCalls;
    if (options.messageCalls) {
      messageCalls = List.generate(messages.length, (i) {
        var message = messages[i];
        var messageCall = generateMessageCall(i, message);
        return messageCall;
      });
    } else {
      messageCalls = [];
    }
    var awaitModifier = options.makeAsync ? 'await' : '';
    var loadLocale = Method(
      (mb) {
        String loading;
        if (options.isWeb) {
          loading = '''
          String data = $awaitModifier _loadingStrategy(carb);
          var messageList = MessageListJson.fromString(data);
        ''';
        } else {
          loading = '''
          Uint8List data = $awaitModifier _loadingStrategy(carb);
          var messageList = MessageListNative.fromBuffer(data);''';
        }
        mb
          ..name = 'loadLocale'
          ..requiredParameters.add(Parameter(
            (p0) => p0
              ..name = 'locale'
              ..type = Reference('String'),
          ))
          ..body = Code('''
          if (!_messages.containsKey(locale)) {
            var carb = _carbs[locale];
            if (carb == null) {
              throw ArgumentError('Locale \$locale is not in \$knownLocales');
            }
            $loading
            if (messageList.hash != _messageListHashes[carb]) {
              throw ArgumentError(
              'Messages file has different hash "\${messageList.hash}" than generated code "\${_messageListHashes[carb]}".');
            }
            _messages[locale] = messageList;
          }
          _currentLocale = locale;
      ''')
          ..returns = getAsyncReference('void', options);

        if (options.makeAsync) {
          mb.modifier = MethodModifier.async;
        }
      },
    );
    var loadAllLocales = Method(
      (mb) {
        mb
          ..name = 'loadAllLocales'
          ..returns = getAsyncReference('void', options)
          ..body = Code('''
          for (var locale in knownLocales) {
            $awaitModifier loadLocale(locale);
          }
      ''');
        if (options.makeAsync) {
          mb.modifier = MethodModifier.async;
        }
      },
    );
    var getKnownLocales = Method(
      (mb) => mb
        ..name = 'knownLocales'
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('_carbs.keys')
        ..returns = Reference('Iterable<String>'),
    );
    var getCurrentMessages = Method(
      (mb) => mb
        ..name = '_currentMessages'
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('_messages[currentLocale]!')
        ..returns = Reference('MessageList'),
    );
    var getCurrentLocale = Method(
      (mb) => mb
        ..name = 'currentLocale'
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('_currentLocale')
        ..returns = Reference('String'),
    );
    var setCurrentLocale = Method(
      (p0) => p0
        ..name = 'currentLocale'
        ..type = MethodType.setter
        ..requiredParameters.add(Parameter(
          (p0) => p0
            ..name = 'locale'
            ..type = Reference('String'),
        ))
        ..body = Code('''
    if (_currentLocale != locale) {
      loadLocale(locale);
    }'''),
    );
    // String getById(String id, List<dynamic> args) {
    //   return _messages[_currentLocale]!
    //       .messages
    //       .firstWhere((element) => element.id == id)
    //       .generateString(args);
    // }
    var getMessagebyId = Method((mb) => mb
      ..name = 'getById'
      ..requiredParameters.addAll([
        Parameter(
          (pb) => pb
            ..name = 'id'
            ..type = Reference('String'),
        )
      ])
      ..optionalParameters.add(Parameter(
        (pb) => pb
          ..name = 'args'
          ..type = Reference('List<dynamic>')
          ..defaultTo = Code('const []'),
      ))
      ..body = Code(
          'return _currentMessages.generateStringAtId(id, ${options.useCleaner ? 'args, cleaner' : 'args'});')
      ..returns = Reference('String'));
    var findByIndex = Method((mb) => mb
      ..name = 'getByIndex'
      ..annotations.add(CodeExpression(Code("pragma('dart2js:noInline')")))
      ..requiredParameters.add(Parameter(
        (pb) => pb
          ..name = 'index'
          ..type = Reference('int'),
      ))
      ..optionalParameters.add(Parameter(
        (pb) => pb
          ..name = 'args'
          ..type = Reference('List<dynamic>')
          ..defaultTo = Code('const []'),
      ))
      ..body = Code('_currentMessages.generateStringAtIndex(index, args)')
      ..lambda = true
      ..returns = Reference('String'));
    var findByEnum = Method((mb) => mb
      ..name = 'getByEnum'
      ..annotations.add(CodeExpression(Code("pragma('dart2js:noInline')")))
      ..requiredParameters.add(Parameter(
        (pb) => pb
          ..name = 'val'
          ..type = Reference(enumName(context)),
      ))
      ..optionalParameters.add(Parameter(
        (pb) => pb
          ..name = 'args'
          ..type = Reference('List<dynamic>')
          ..defaultTo = Code('const []'),
      ))
      ..body = Code('_currentMessages.generateStringAtIndex(val.index, args)')
      ..lambda = true
      ..returns = Reference('String'));

    var deferredLoadingStrategy = Method((mb) {
      mb
        ..name = '_loadingStrategy'
        ..requiredParameters.add(Parameter(
          (pb) => pb
            ..name = 'id'
            ..type = Reference('String'),
        ))
        ..body = Code('''
    ${resourceToHash.keys.map((e) => '''
    if (id == '$e') {
      ${options.makeAsync ? 'await ${getDataFileName(e)}.loadLibrary();' : ''}
      return ${getDataFileName(e)}.JsonData.jsonData;
    }
    ''').join(' else ')}
    throw ArgumentError();
    ''')
        ..returns = getAsyncReference('String', options);
      if (options.makeAsync) {
        mb.modifier = MethodModifier.async;
      }
    });
    return [
      if (options.isWeb) deferredLoadingStrategy,
      getCurrentLocale,
      getCurrentMessages,
      if (!options.makeAsync) setCurrentLocale,
      if (options.findById) getMessagebyId,
      if (options.findByEnum) findByEnum,
      if (options.findByIndex) findByIndex,
      getKnownLocales,
      loadLocale,
      loadAllLocales,
      ...messageCalls,
    ];
  }
}
