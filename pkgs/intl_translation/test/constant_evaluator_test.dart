// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:intl_translation/src/messages/constant_evaluator.dart';
import 'package:test/test.dart';

void main() {
  group('Constant class', () {
    test('should wrap non-null values', () {
      final constant = Constant('test');
      expect(constant.value, 'test');
    });

    test('should wrap null values', () {
      final constant = Constant<String?>(null);
      expect(constant.value, isNull);
    });

    test('nullable should return null for null input', () {
      final result = Constant.nullable<String>(null);
      expect(result, isNull);
    });

    test('nullable should wrap non-null values', () {
      final result = Constant.nullable('test');
      expect(result, isNotNull);
      expect(result!.value, 'test');
    });
  });

  group('evaluate function', () {
    test('should evaluate SimpleStringLiteral', () {
      final expression =
          _parseExpression('"hello world"') as SimpleStringLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, 'hello world');
    });

    test('should evaluate AdjacentStrings', () {
      final expression =
          _parseExpression('"hello " "world"') as AdjacentStrings;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, 'hello world');
    });

    test('should evaluate IntegerLiteral', () {
      final expression = _parseExpression('42') as IntegerLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, 42);
    });

    test('should evaluate DoubleLiteral', () {
      final expression = _parseExpression('3.14') as DoubleLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, 3.14);
    });

    test('should evaluate BooleanLiteral true', () {
      final expression = _parseExpression('true') as BooleanLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, true);
    });

    test('should evaluate BooleanLiteral false', () {
      final expression = _parseExpression('false') as BooleanLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, false);
    });

    test('should evaluate NullLiteral', () {
      final expression = _parseExpression('null') as NullLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, isNull);
    });

    test('should evaluate const SetOrMapLiteral (map)', () {
      final expression = _parseExpression('const {"key": "value", "num": 42}')
          as SetOrMapLiteral;
      final result = evaluate(expression);

      expect(result, isNotNull);
      expect(result!.value, isA<Map<String, dynamic>>());
      final map = result.value as Map<String, dynamic>;
      expect(map['key'], 'value');
      expect(map['num'], 42);
    });

    test('should return null for unsupported expressions', () {
      final expression = _parseExpression('someVariable') as SimpleIdentifier;
      final result = evaluate(expression);

      expect(result, isNull);
    });

    test('should return null for function calls', () {
      final expression = _parseExpression('someFunction()') as MethodInvocation;
      final result = evaluate(expression);

      expect(result, isNull);
    });
  });

  group('evaluateConstString function', () {
    test('should evaluate SimpleStringLiteral', () {
      final expression = _parseExpression('"hello"') as SimpleStringLiteral;
      final result = evaluateConstString(expression);

      expect(result, 'hello');
    });

    test('should evaluate AdjacentStrings with multiple parts', () {
      final expression =
          _parseExpression('"hello " "beautiful " "world"') as AdjacentStrings;
      final result = evaluateConstString(expression);

      expect(result, 'hello beautiful world');
    });

    test('should evaluate AdjacentStrings with empty string', () {
      final expression =
          _parseExpression('"hello" "" "world"') as AdjacentStrings;
      final result = evaluateConstString(expression);

      expect(result, 'helloworld');
    });

    test('should return null for non-string expressions', () {
      final expression = _parseExpression('42') as IntegerLiteral;
      final result = evaluateConstString(expression);

      expect(result, isNull);
    });

    test('should return null for string interpolation', () {
      final expression =
          _parseExpression(r'"hello ${variable}"') as StringInterpolation;
      final result = evaluateConstString(expression);

      expect(result, isNull);
    });
  });

  group('evaluateConstStringMap function', () {
    test('should evaluate const map with string keys and mixed values', () {
      final expression = _parseExpression(
              'const {"str": "value", "num": 42, "bool": true, "nil": null}')
          as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final map = result!.value as Map<String, dynamic>;
      expect(map['str'], 'value');
      expect(map['num'], 42);
      expect(map['bool'], true);
      expect(map['nil'], isNull);
    });

    test('should evaluate const empty map', () {
      final expression =
          _parseExpression('const <String, dynamic>{}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      expect(result!.value, isA<Map<String, dynamic>>());
      expect((result.value).isEmpty, isTrue);
    });

    test('should return null for non-const map', () {
      final expression =
          _parseExpression('{"key": "value"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should return null for const set', () {
      final expression =
          _parseExpression('const {"item1", "item2"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should return null for map with spread elements', () {
      final expression =
          _parseExpression('const {...other}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should return null for map with non-evaluable keys', () {
      final expression =
          _parseExpression('const {someVariable: "value"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should return null for map with non-evaluable values', () {
      final expression =
          _parseExpression('const {"key": someVariable}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should return null for map with non-string keys', () {
      final expression =
          _parseExpression('const {42: "value"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should handle nested const maps', () {
      final expression =
          _parseExpression('const {"outer": const {"inner": "value"}}')
              as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final outerMap = result!.value as Map<String, dynamic>;
      expect(outerMap['outer'], isA<Map<String, dynamic>>());
      final innerMap = outerMap['outer'] as Map<String, dynamic>;
      expect(innerMap['inner'], 'value');
    });
  });

  group('Recursive and complex scenarios', () {
    test('should handle nested AdjacentStrings in map values', () {
      final expression = _parseExpression('const {"key": "hello " "world"}')
          as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final map = result!.value as Map<String, dynamic>;
      expect(map['key'], 'hello world');
    });

    test('should handle nested AdjacentStrings in map keys', () {
      final expression = _parseExpression('const {"hello " "world": "value"}')
          as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final map = result!.value as Map<String, dynamic>;
      expect(map['hello world'], 'value');
    });

    test('should handle deeply nested const structures', () {
      final expression = _parseExpression('''
        const {
          "level1": const {
            "level2": const {
              "level3": "deep " "value"
            }
          }
        }
      ''') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final level1 = result!.value as Map<String, dynamic>;
      final level2 = level1['level1'] as Map<String, dynamic>;
      final level3 = level2['level2'] as Map<String, dynamic>;
      expect(level3['level3'], 'deep value');
    });

    test('should handle AdjacentStrings with many parts', () {
      final expression =
          _parseExpression('"a" "b" "c" "d" "e"') as AdjacentStrings;
      final result = evaluateConstString(expression);

      expect(result, 'abcde');
    });

    test('should handle complex map with all supported literal types', () {
      final expression = _parseExpression('''
        const {
          "string": "hello " "world",
          "integer": 42,
          "double": 3.14,
          "boolean_true": true,
          "boolean_false": false,
          "null_value": null,
          "nested_map": const {
            "inner": "value"
          }
        }
      ''') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNotNull);
      final map = result!.value as Map<String, dynamic>;
      expect(map['string'], 'hello world');
      expect(map['integer'], 42);
      expect(map['double'], 3.14);
      expect(map['boolean_true'], true);
      expect(map['boolean_false'], false);
      expect(map['null_value'], isNull);
      expect(map['nested_map'], isA<Map<String, dynamic>>());
      final nestedMap = map['nested_map'] as Map<String, dynamic>;
      expect(nestedMap['inner'], 'value');
    });

    test('should handle AdjacentStrings with non-evaluable children', () {
      final identifierExpression =
          _parseExpression('someVariable') as SimpleIdentifier;
      final result = evaluateConstString(identifierExpression);

      expect(result, isNull);
    });

    test('should handle empty string in AdjacentStrings', () {
      final expression = _parseExpression('""') as SimpleStringLiteral;
      final result = evaluateConstString(expression);

      expect(result, '');
    });
  });

  group('Edge cases and error conditions', () {
    test('evaluate should handle very large integers', () {
      final expression = _parseExpression('9223372036854775807')
          as IntegerLiteral; // Max int64
      final result = evaluate(expression);

      expect(result!.value, 9223372036854775807);
    });

    test('evaluate should handle negative integers', () {
      final expression = _parseExpression('-42') as PrefixExpression;
      final result = evaluate(expression);

      expect(result, isNull);
    });

    test('evaluate should handle very small doubles', () {
      final expression = _parseExpression('1e-100') as DoubleLiteral;
      final result = evaluate(expression);

      expect(result!.value, 1e-100);
    });

    test('evaluateConstStringMap should handle map with duplicate keys', () {
      final expression =
          _parseExpression('const {"key": "first", "key": "second"}')
              as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      final map = result!.value as Map<String, dynamic>;
      expect(map['key'], 'second');
    });

    test('should handle mixed string types in AdjacentStrings', () {
      // Test with single and double quoted strings
      final expression =
          _parseExpression("'single' \"double\"") as AdjacentStrings;
      final result = evaluateConstString(expression);

      expect(result, 'singledouble');
    });

    test('should handle escape sequences in strings', () {
      final expression =
          _parseExpression(r'"hello\nworld"') as SimpleStringLiteral;
      final result = evaluateConstString(expression);

      expect(result, 'hello\nworld');
    });

    test('should handle const list', () {
      final expression = _parseExpression('const [1, 2, 3]') as ListLiteral;
      final result = evaluate(expression);

      expect(result, isNull);
    });
  });

  group('_checkChildren helper function edge cases', () {
    test('should handle empty AdjacentStrings', () {
      final expression = _parseExpression('"" ""') as AdjacentStrings;
      final result = evaluateConstString(expression);

      expect(result, '');
    });

    test('should handle single string in AdjacentStrings', () {
      final expression = _parseExpression('"single"') as SimpleStringLiteral;
      final result = evaluateConstString(expression);

      expect(result, 'single');
    });
  });

  group('Additional coverage for completeness', () {
    test('should handle const map with if elements', () {
      final expression = _parseExpression('const {if (true) "key": "value"}')
          as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should handle const map with for elements', () {
      final expression = _parseExpression('const {for (var i in items) i: i}')
          as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should handle map with null key', () {
      final expression =
          _parseExpression('const {null: "value"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });

    test('should handle map with boolean key', () {
      final expression =
          _parseExpression('const {true: "value"}') as SetOrMapLiteral;
      final result = evaluateConstStringMap(expression);

      expect(result, isNull);
    });
  });
}

/// Helper function to parse a single expression from a string
Expression _parseExpression(String code) {
  final unit = parseString(
    content: 'var x = $code;',
    featureSet: FeatureSet.latestLanguageVersion(),
  ).unit;

  final variableDeclaration =
      unit.declarations.first as TopLevelVariableDeclaration;
  final variable = variableDeclaration.variables.variables.first;
  return variable.initializer!;
}
