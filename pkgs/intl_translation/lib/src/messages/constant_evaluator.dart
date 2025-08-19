// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';

/// Needed to wrap `null` as a valid constant value
class Constant<T extends Object?> {
  final T value;

  Constant(this.value);

  static Constant<T>? nullable<T extends Object>(T? o) =>
      o == null ? null : Constant(o);
}

Constant? evaluate(Expression expression) {
  return switch (expression) {
    AdjacentStrings() => Constant.nullable(evaluateConstString(expression)),
    SimpleStringLiteral() => Constant(expression.value),
    IntegerLiteral() => Constant(expression.value),
    DoubleLiteral() => Constant(expression.value),
    BooleanLiteral() => Constant(expression.value),
    NullLiteral() => Constant(null),
    SetOrMapLiteral() => evaluateConstStringMap(expression),
    _ => null,
  };
}

String? evaluateConstString(Expression expression) => switch (expression) {
  SimpleStringLiteral() => expression.value,
  AdjacentStrings() => _checkChildren(expression.strings)?.join(),
  _ => null,
};

Iterable<String>? _checkChildren(Iterable<StringLiteral> strings) {
  final constExpressions = strings.map((string) => evaluateConstString(string));
  return constExpressions.any((string) => string == null)
      ? null
      : constExpressions.whereType();
}

Constant<Map>? evaluateConstStringMap(SetOrMapLiteral map) {
  if (!map.isConst) {
    return null;
  }
  if (map.elements.any((element) => element is! MapLiteralEntry)) {
    return null;
  }
  final evaluatedEntries = map.elements.whereType<MapLiteralEntry>().map(
    (literalEntry) => (
      evaluate(literalEntry.key),
      evaluate(literalEntry.value),
    ),
  );
  if (evaluatedEntries.any(
    (element) => element.$1 == null || element.$2 == null,
  )) {
    return null;
  }
  var extractedValues = evaluatedEntries.map(
    (literalEntry) => MapEntry(literalEntry.$1!.value, literalEntry.$2!.value),
  );
  if (extractedValues.any((element) => element.key is! String)) {
    return null;
  }
  return Constant(
    Map<String, dynamic>.fromEntries(
      extractedValues.map((e) => MapEntry(e.key as String, e.value)),
    ),
  );
}
