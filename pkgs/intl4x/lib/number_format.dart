// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Provides locale-sensitive number formatting.
///
/// Use the [NumberFormat] class to format numbers in a locale-sensitive
/// manner.
///
/// ```dart
/// import 'package:intl4x/number_format.dart';
///
/// void main(List<String> arguments) {
///   print(
///     NumberFormat(
///       roundingMode: RoundingMode.ceil,
///       digits: const Digits.withFractionDigits(maximum: 1),
///     ).format(3.14),
///   );
/// }
///
/// ```
library;

import 'src/number_format/number_format.dart' show NumberFormat;

export 'src/locale/locale.dart' show Locale;
export 'src/number_format/number_format.dart' show NumberFormat;
export 'src/number_format/number_format_options.dart'
    show
        CompactDisplay,
        CompactNotation,
        CurrencyDisplay,
        CurrencySign,
        CurrencyStyle,
        DecimalStyle,
        Digits,
        EngineeringNotation,
        FormatStyle,
        FractionDigits,
        Grouping,
        Notation,
        PercentStyle,
        RoundingMode,
        RoundingPriority,
        ScientificNotation,
        SignDisplay,
        SignificantDigits,
        StandardNotation,
        TrailingZeroDisplay,
        Unit,
        UnitDisplay,
        UnitStyle;
