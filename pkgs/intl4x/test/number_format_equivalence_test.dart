// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:intl4x/datetime_format.dart' show NumberingSystem;
import 'package:intl4x/number_format.dart';
import 'package:test/test.dart';

import 'utils.dart';

/// The seed for the random option combinations. It is fixed so that failures
/// are reproducible.
const _seed = 42;

/// The number of random option combinations to check per constructor.
const _iterations = 300;

/// Checks that the convenience constructors format exactly like the general
/// [NumberFormat] constructor with the equivalent style or notation, for
/// random combinations of options, and that no combination throws.
void main() {
  group('convenience constructors match NumberFormat()', () {
    testWithFormatting(
      'percent',
      () => _expectEquivalent(
        (o) => NumberFormat.percent(
          locale: o.locale,
          signDisplay: o.signDisplay,
          notation: o.notation,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
        (o) => NumberFormat(
          locale: o.locale,
          style: const PercentStyle(),
          signDisplay: o.signDisplay,
          notation: o.notation,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
      ),
    );

    testWithFormatting(
      'compact',
      () => _expectEquivalent(
        (o) => NumberFormat.compact(
          locale: o.locale,
          compactDisplay: o.compactDisplay,
          style: o.compactStyle,
          signDisplay: o.signDisplay,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
        (o) => NumberFormat(
          locale: o.locale,
          style: o.compactStyle,
          notation: CompactNotation(compactDisplay: o.compactDisplay),
          signDisplay: o.signDisplay,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
      ),
    );

    testWithFormatting(
      'currency',
      () => _expectEquivalent(
        (o) => NumberFormat.currency(
          locale: o.locale,
          currency: o.currency,
          currencyDisplay: o.currencyDisplay,
          currencySign: o.currencySign,
          signDisplay: o.signDisplay,
          notation: o.notation,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
        (o) => NumberFormat(
          locale: o.locale,
          style: CurrencyStyle(
            currency: o.currency,
            display: o.currencyDisplay,
            sign: o.currencySign,
          ),
          currency: o.currency,
          signDisplay: o.signDisplay,
          notation: o.notation,
          useGrouping: o.useGrouping,
          numberingSystem: o.numberingSystem,
          roundingMode: o.roundingMode,
          trailingZeroDisplay: o.trailingZeroDisplay,
          minimumIntegerDigits: o.minimumIntegerDigits,
          digits: o.digits,
        ),
      ),
    );
  }, tags: ['icu4xUnimplemented']);
}

void _expectEquivalent(
  NumberFormat Function(_Options options) convenience,
  NumberFormat Function(_Options options) general,
) {
  final random = Random(_seed);
  final failures = <String>[];
  for (var i = 0; i < _iterations; i++) {
    final options = _Options.random(random);
    final actual = _format(() => convenience(options), options.number);
    final expected = _format(() => general(options), options.number);
    if (actual != expected) {
      failures.add('Got "$actual" instead of "$expected" for $options');
    } else if (actual.startsWith(_throws)) {
      failures.add('Got "$actual" for $options');
    }
  }
  if (failures.isNotEmpty) {
    fail(
      '${failures.length} of $_iterations option combinations failed '
      '(seed $_seed). First failures:\n${failures.take(5).join('\n')}',
    );
  }
}

const _throws = 'throws ';

String _format(NumberFormat Function() create, num number) {
  try {
    return create().format(number);
  } catch (e) {
    return '$_throws$e';
  }
}

/// A random combination of [NumberFormat] options and a number to format.
final class _Options {
  final num number;
  final Locale locale;
  final SignDisplay signDisplay;
  final Notation notation;
  final CompactDisplay compactDisplay;
  final FormatStyle compactStyle;
  final Grouping useGrouping;
  final NumberingSystem? numberingSystem;
  final RoundingMode roundingMode;
  final TrailingZeroDisplay trailingZeroDisplay;
  final int minimumIntegerDigits;
  final Digits? digits;
  final String currency;
  final CurrencyDisplay currencyDisplay;
  final CurrencySign currencySign;

  _Options._({
    required this.number,
    required this.locale,
    required this.signDisplay,
    required this.notation,
    required this.compactDisplay,
    required this.compactStyle,
    required this.useGrouping,
    required this.numberingSystem,
    required this.roundingMode,
    required this.trailingZeroDisplay,
    required this.minimumIntegerDigits,
    required this.digits,
    required this.currency,
    required this.currencyDisplay,
    required this.currencySign,
  });

  factory _Options.random(Random random) {
    T pick<T>(List<T> values) => values[random.nextInt(values.length)];
    final currency = pick(['USD', 'EUR', 'JPY']);
    final currencyDisplay = pick(CurrencyDisplay.values);
    final currencySign = pick(CurrencySign.values);
    final compactDisplay = pick(CompactDisplay.values);
    return _Options._(
      number: pick<num Function()>([
        () => pick<num>([0, 0.045, 0.5, 1.005, -1.5, 1234.5678, -98765.4321]),
        () => random.nextInt(2000000) - 1000000,
        () => (random.nextDouble() - 0.5) * pow(10, random.nextInt(8)),
      ])(),
      locale: Locale.parse(pick(['en-US', 'de', 'fr', 'hi', 'ja', 'ar-EG'])),
      signDisplay: pick(SignDisplay.values),
      notation: pick<Notation>([
        const StandardNotation(),
        ScientificNotation(),
        EngineeringNotation(),
        CompactNotation(compactDisplay: compactDisplay),
      ]),
      compactDisplay: compactDisplay,
      compactStyle: pick<FormatStyle>([
        const DecimalStyle(),
        const PercentStyle(),
        CurrencyStyle(
          currency: currency,
          display: currencyDisplay,
          sign: currencySign,
        ),
        UnitStyle(
          unit: pick(Unit.values),
          unitDisplay: pick(UnitDisplay.values),
        ),
      ]),
      useGrouping: pick(Grouping.values),
      numberingSystem: pick([null, ...NumberingSystem.values]),
      roundingMode: pick(RoundingMode.values),
      trailingZeroDisplay: pick(TrailingZeroDisplay.values),
      minimumIntegerDigits: 1 + random.nextInt(3),
      digits: _randomDigits(random, pick),
      currency: currency,
      currencyDisplay: currencyDisplay,
      currencySign: currencySign,
    );
  }

  static Digits? _randomDigits(
    Random random,
    T Function<T>(List<T> values) pick,
  ) {
    int? maybe(int value) => random.nextBool() ? value : null;
    switch (random.nextInt(4)) {
      case 0:
        return null;
      case 1:
        final minimum = maybe(random.nextInt(4));
        final maximum = maybe((minimum ?? 0) + random.nextInt(4));
        return Digits.withFractionDigits(minimum: minimum, maximum: maximum);
      case 2:
        final minimum = 1 + random.nextInt(3);
        return Digits.withSignificantDigits(
          minimum: minimum,
          maximum: minimum + random.nextInt(4),
        );
      default:
        final minimumSignificantDigits = 1 + random.nextInt(3);
        final minimumFractionDigits = random.nextInt(3);
        return Digits.withSignificantAndFractionDigits(
          minimumSignificantDigits: minimumSignificantDigits,
          maximumSignificantDigits:
              minimumSignificantDigits + random.nextInt(4),
          minimumFractionDigits: minimumFractionDigits,
          maximumFractionDigits: minimumFractionDigits + random.nextInt(4),
          roundingPriority: pick(RoundingPriority.values),
        );
    }
  }

  @override
  String toString() {
    final digits = this.digits;
    final digitsDescription = digits == null
        ? 'null'
        : 'fraction ${digits.fractionDigits}, '
              'significant ${digits.significantDigits}, '
              'roundingPriority ${digits.roundingPriority?.name}';
    return 'number $number, locale $locale, '
        'signDisplay ${signDisplay.name}, notation ${notation.name}, '
        'compactDisplay ${compactDisplay.name}, '
        'compactStyle ${compactStyle.name}, '
        'useGrouping ${useGrouping.name}, '
        'numberingSystem ${numberingSystem?.name}, '
        'roundingMode ${roundingMode.name}, '
        'trailingZeroDisplay ${trailingZeroDisplay.name}, '
        'minimumIntegerDigits $minimumIntegerDigits, '
        'digits ($digitsDescription), currency $currency, '
        'currencyDisplay ${currencyDisplay.name}, '
        'currencySign ${currencySign.name}';
  }
}
