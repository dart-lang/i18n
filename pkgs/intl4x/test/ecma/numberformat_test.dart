// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
library;

import 'dart:math';

import 'package:intl4x/intl4x.dart';
import 'package:intl4x/number_format.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:test/test.dart';

import '../utils.dart';

@JS('Intl.NumberFormat')
class _NumberFormatJS {
  external factory _NumberFormatJS([List<String> locale, Object options]);
  external String format(Object num);
}

Object generateProperties(Map<String, Object> properties) {
  final object = Object();
  for (final entry in properties.entries) {
    setProperty(object, entry.key, entry.value);
  }
  return object;
}

void main() {
  group('Some manual tests', () {
    final intl = Intl(locale: const Locale(language: 'en', region: 'US'));

    testWithFormatting('significantDigits', () {
      final numberFormatOptions = intl.numberFormat(NumberFormatOptions.custom(
        digits: const Digits.withSignificantDigits(minimum: 1, maximum: 3),
      ));

      expect(numberFormatOptions.format(3), '3');
      expect(numberFormatOptions.format(3.1), '3.1');
      expect(numberFormatOptions.format(3.12), '3.12');
      expect(numberFormatOptions.format(3.123), '3.12');
    });

    testWithFormatting('fractionDigits', () {
      String formatter(Object number) => intl
          .numberFormat(NumberFormatOptions.custom(
            minimumIntegerDigits: 3,
            digits: const Digits.withFractionDigits(minimum: 4),
          ))
          .format(number);
      expect(formatter(4.33), '004.3300');
    });

    testWithFormatting('percent', () {
      expect(intl.numberFormat(NumberFormatOptions.percent()).format(4.33),
          '433%');
    });

    testWithFormatting('compact', () {
      expect(
          intl.numberFormat(NumberFormatOptions.compact()).format(4.33), '4.3');
    });
  });

  testWithFormatting('Some fuzzy testing', () {
    final seed = Random().nextInt(1 << 31);
    print('Seed: $seed');
    final random = Random(seed);

    final numbers = [3.14, 5, 20000, 3, 4.2214, 3.99999, 20000.0001];
    final locales = [
      const Locale(language: 'en', region: 'US'),
      const Locale(language: 'de', region: 'DE'),
      const Locale(language: 'zh', region: 'TW')
    ];
    final options = <(Object, NumberFormatOptions, Object)>[
      (
        {'minimumFractionDigits': 2},
        NumberFormatOptions.custom(
          digits: const Digits.withFractionDigits(minimum: 2),
        ),
        generateProperties({'minimumFractionDigits': 2}),
      ),
      (
        'useGrouping',
        NumberFormatOptions.custom(useGrouping: Grouping.always),
        generateProperties({'useGrouping': true}),
      ),
      (
        'USD',
        NumberFormatOptions.currency(currency: 'USD'),
        generateProperties({'style': 'currency', 'currency': 'USD'}),
      ),
      (
        'percent',
        NumberFormatOptions.percent(),
        generateProperties({'style': 'percent'}),
      ),
    ];

    List<(num, Locale, (Object, NumberFormatOptions, Object))>
        selectIndicesFrom(int length) {
      return List.generate(
          length,
          (index) => (
                numbers[random.nextInt(numbers.length)],
                locales[random.nextInt(locales.length)],
                options[random.nextInt(options.length)]
              )).toSet().toList();
    }

    for (final (number, locale, (desc, options, object))
        in selectIndicesFrom(1000)) {
      final jsFormat =
          _NumberFormatJS([locale.toLanguageTag()], object).format(number);
      final dartFormat =
          Intl(locale: locale).numberFormat(options).format(number);
      expect(dartFormat, jsFormat,
          reason: 'With number $number, locale $locale, options $desc');
    }
  });
}
