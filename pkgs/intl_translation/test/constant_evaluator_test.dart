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
    test('should wrap values including null', () {
      final stringConstant = Constant('test');
      expect(stringConstant.value, 'test');

      final nullConstant = Constant<String?>(null);
      expect(nullConstant.value, isNull);
    });

    test('nullable should handle null and non-null values', () {
      expect(Constant.nullable<String>(null), isNull);

      final result = Constant.nullable('test');
      expect(result!.value, 'test');
    });
  });

  group('evaluate function', () {
    test('should evaluate all basic literal types', () {
      expect(
        evaluate(_parseExpression('"hello"') as SimpleStringLiteral)!.value,
        'hello',
      );
      expect(evaluate(_parseExpression('42') as IntegerLiteral)!.value, 42);
      expect(evaluate(_parseExpression('3.14') as DoubleLiteral)!.value, 3.14);
      expect(evaluate(_parseExpression('true') as BooleanLiteral)!.value, true);
      expect(evaluate(_parseExpression('null') as NullLiteral)!.value, isNull);
    });

    test('should evaluate AdjacentStrings', () {
      final result = evaluate(
        _parseExpression('"hello " "world"') as AdjacentStrings,
      );
      expect(result!.value, 'hello world');
    });

    test('should evaluate const maps', () {
      final result = evaluate(
        _parseExpression('const {"key": "value", "num": 42}')
            as SetOrMapLiteral,
      );
      final map = result!.value as Map<String, dynamic>;
      expect(map['key'], 'value');
      expect(map['num'], 42);
    });

    test('should return null for unsupported expressions', () {
      expect(
        evaluate(_parseExpression('someVariable') as SimpleIdentifier),
        isNull,
      );
      expect(
        evaluate(_parseExpression('someFunction()') as MethodInvocation),
        isNull,
      );
    });
  });

  group('evaluateConstString function', () {
    test('should evaluate string literals and adjacent strings', () {
      expect(
        evaluateConstString(_parseExpression('"hello"') as SimpleStringLiteral),
        'hello',
      );
      expect(
        evaluateConstString(
          _parseExpression('"hello " "world"') as AdjacentStrings,
        ),
        'hello world',
      );
    });

    test('should return null for non-string expressions', () {
      expect(
        evaluateConstString(_parseExpression('42') as IntegerLiteral),
        isNull,
      );
      expect(
        evaluateConstString(
          _parseExpression(r'"hello ${variable}"') as StringInterpolation,
        ),
        isNull,
      );
    });
  });

  group('evaluateConstStringMap function', () {
    test('should evaluate const maps with string keys', () {
      final result = evaluateConstStringMap(
        _parseExpression(
              'const {"str": "value", "num": 42, "bool": true, "nil": null}',
            )
            as SetOrMapLiteral,
      );
      final map = result!.value as Map<String, dynamic>;
      expect(map['str'], 'value');
      expect(map['num'], 42);
      expect(map['bool'], true);
      expect(map['nil'], isNull);
    });

    test('should handle nested maps and adjacent strings', () {
      final result = evaluateConstStringMap(
        _parseExpression('const {"outer": const {"inner": "hello " "world"}}')
            as SetOrMapLiteral,
      );
      final outerMap = result!.value as Map<String, dynamic>;
      final innerMap = outerMap['outer'] as Map<String, dynamic>;
      expect(innerMap['inner'], 'hello world');
    });

    test('should return null for invalid cases', () {
      // Non-const map
      expect(
        evaluateConstStringMap(
          _parseExpression('{"key": "value"}') as SetOrMapLiteral,
        ),
        isNull,
      );

      // Const set (not map)
      expect(
        evaluateConstStringMap(
          _parseExpression('const {"item1", "item2"}') as SetOrMapLiteral,
        ),
        isNull,
      );

      // Non-string keys
      expect(
        evaluateConstStringMap(
          _parseExpression('const {42: "value"}') as SetOrMapLiteral,
        ),
        isNull,
      );

      // Non-evaluable values
      expect(
        evaluateConstStringMap(
          _parseExpression('const {"key": someVariable}') as SetOrMapLiteral,
        ),
        isNull,
      );
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
