// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/src/intl/number_parser_base.dart';

/// A one-time object for parsing a particular numeric string. One-time here
/// means an instance can only parse one string. This is implemented by
/// transforming from a locale-specific format to one that the system can parse,
/// then calls the system parsing methods on it.
class NumberParser extends NumberParserBase<num> {
  /// Create a new [_NumberParser] on which we can call parse().
  NumberParser(super.format, super.text);

  @override
  num fromNormalized(String normalizedText) =>
      int.tryParse(normalizedText) ?? double.parse(normalizedText);

  @override
  num scaled(num parsed, int scale) => parsed / scale;

  @override
  num nan() => 0.0 / 0.0;

  @override
  num positiveInfinity() => 1.0 / 0.0;

  @override
  num negativeInfinity() => -1.0 / 0.0;
}
