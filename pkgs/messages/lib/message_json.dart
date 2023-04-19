// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_util';

import 'package:intl/intl.dart' as old_intl;
import 'package:js/js.dart';
import 'package:messages/message_format.dart';

@JS('JSON.parse')
external Object _jsonParse(String data);

class MessageListJson extends MessageList {
  final dynamic _parsed;

  @override
  String get locale => _parsed[1];

  @override
  String get hash => _parsed[2];

  @override
  bool get hasIds => _parsed[3] == 1;

  MessageListJson.fromString(String data) : _parsed = _jsonParse(data) {
    if (_parsed[0] != VERSION) {
      throw ArgumentError(
          'This message has version ${_parsed[0]}, while the deserializer has version $VERSION');
    }
  }

  @override
  String generateStringAtIndex(int index, List<dynamic> args) {
    var messageIndex = jsonPreambleLength + index;
    return _generateStringAtMessageIndex(messageIndex, args);
  }

  String _generateStringAtMessageIndex(int messageIndex, List<dynamic> args) =>
      _generateStringFor(_parsed[messageIndex], args);

  @override
  String generateStringAtId(String id, List args) {
    for (var i = jsonPreambleLength; i < _parsed.length; i++) {
      var message = _parsed[i];
      if (message[2] == id) {
        return _generateStringFor(message, args);
      }
    }
    throw ArgumentError('Unknown message id "$id"');
  }

  String _generateStringFor(dynamic message, List<dynamic> args) {
    if (message is List) {
      var type = message[0];
      var start = hasIds ? 2 : 1;
      if (type == PluralMessage.type) {
        return _forPlural(message, start, args);
      } else if (type == SelectMessage.type) {
        return _forSelect(message, start, args);
      } else if (type == GenderMessage.type) {
        return _forGender(message, start, args);
      } else if (type == CombinedMessage.type) {
        return _forCombined(message, start, args);
      } else {
        return _forString(message, start - 1, args);
      }
    } else if (!hasIds && message is String) {
      return message;
    }
    throw ArgumentError();
  }

  String _forString(List<dynamic> message, int start, List<dynamic> args) {
    var str = message[start] as String;
    var argIndices = <List<dynamic>>[];
    for (var i = start + 1; i < message.length; i++) {
      argIndices.add(message[i]);
    }
    var sb = StringBuffer();
    var position = 0;
    for (var i = 0; i < argIndices.length; i++) {
      var nextPosition = int.parse(argIndices[i][0], radix: 36);
      sb.write(str.substring(position, nextPosition));
      var argIndex = argIndices[i][1];
      sb.write(args[argIndex]);
      position = nextPosition;
    }
    sb.write(str.substring(position, str.length));
    return sb.toString();
  }

  String _forPlural(List<dynamic> message, int start, List<dynamic> args) {
    var argIndex = message[start];
    var otherMessage = _generateStringFor(message[start + 1], args);
    var submessages = message[start + 2];
    String? zeroWordMessage;
    String? zeroNumberMessage;
    String? oneWordMessage;
    String? oneNumberMessage;
    String? twoWordMessage;
    String? twoNumberMessage;
    String? fewMessage;
    String? manyMessage;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      var msg = _generateStringFor(submessages[i + 1], args);
      switch (submessages[i]) {
        case Plural.zeroWord:
          zeroWordMessage = msg;
          break;
        case Plural.zeroNumber:
          zeroNumberMessage = msg;
          break;
        case Plural.oneWord:
          oneWordMessage = msg;
          break;
        case Plural.oneNumber:
          oneNumberMessage = msg;
          break;
        case Plural.twoWord:
          twoWordMessage = msg;
          break;
        case Plural.twoNumber:
          twoNumberMessage = msg;
          break;
        case Plural.few:
          fewMessage = msg;
          break;
        case Plural.many:
          manyMessage = msg;
          break;
      }
    }
    return old_intl.Intl.pluralLogic(
      args[argIndex],
      zero: zeroNumberMessage ?? zeroWordMessage,
      one: oneNumberMessage ?? oneWordMessage,
      two: twoNumberMessage ?? twoWordMessage,
      few: fewMessage,
      many: manyMessage,
      other: otherMessage,
    );
  }

  String _forSelect(List message, int start, List<dynamic> args) {
    var argIndex = message[start];
    var otherCase = message[start + 1];
    var submessages = message[start + 2];
    var keys = objectKeys(submessages);
    var cases = <Object, String>{'other': _generateStringFor(otherCase, args)};
    for (var key in keys) {
      if (key != null) {
        cases[key.toString()] =
            _generateStringFor(getProperty(submessages, key), args);
      }
    }
    return old_intl.Intl.selectLogic(args[argIndex], cases);
  }

  String _forCombined(List<dynamic> message, int start, List<dynamic> args) {
    return message
        .skip(start)
        .map((message) => _generateStringFor(message, args))
        .join();
  }

  String _forGender(List<dynamic> message, int start, List<dynamic> args) {
    var argIndex = message[start];
    var otherMessage = _generateStringFor(message[start + 1], args);
    var submessages = message[start + 2];
    String? femaleMessage;
    String? maleMessage;
    for (var i = 0; i < submessages.length - 1; i += 2) {
      var msg = _generateStringFor(submessages[i + 1], args);
      switch (submessages[i]) {
        case Gender.female:
          femaleMessage = msg;
          break;
        case Gender.male:
          maleMessage = msg;
          break;
      }
    }
    return old_intl.Intl.genderLogic(
      args[argIndex],
      other: otherMessage,
      female: femaleMessage,
      male: maleMessage,
    );
  }
}
