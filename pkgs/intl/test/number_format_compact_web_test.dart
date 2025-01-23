// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(b/36488375): run all these tests against both implementations to prove
// consistency when the bug is fixed. Also fix documentation and perhaps
// merge tests: these tests currently also touch non-compact currency
// formatting.

/// Tests for compact number formatting in pure Dart and in ECMAScript.
@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:intl/intl.dart' as intl;
import 'package:test/test.dart';

import 'compact_number_test_data.dart' as testdata;
import 'more_compact_number_test_data.dart' as more_testdata;

extension on JSNumber {
  external String toLocaleString(String locale, [JSObject? options]);
}

void main() {
  testdata.compactNumberTestData.forEach(_validate);
  more_testdata.cldr35CompactNumTests.forEach(_validateMore);

  test('RTL currency formatting', () {
    var basic = intl.NumberFormat.currency(locale: 'he');
    expect(basic.format(1234), '\u200F1,234.00\u00A0\u200FILS');
    basic = intl.NumberFormat.currency(locale: 'he', symbol: '₪');
    expect(basic.format(1234), '\u200F1,234.00\u00A0\u200F₪');
    expect(_ecmaFormatNumber('he', 1234, style: 'currency', currency: 'ILS'),
        '\u200F1,234.00\u00A0\u200F₪');

    var compact = intl.NumberFormat.compactCurrency(locale: 'he');
    expect(compact.format(1234), 'ILS1.23K\u200F');
    compact = intl.NumberFormat.compactCurrency(locale: 'he', symbol: '₪');
    expect(compact.format(1234), '₪1.23K\u200F');
    // ECMAScript skips the RTL character for notation:'compact':
    expect(
        _ecmaFormatNumber('he', 1234,
            style: 'currency', currency: 'ILS', notation: 'compact'),
        '₪1.2K\u200F');
    // short/long compactDisplay doesn't change anything here:
    expect(
        _ecmaFormatNumber('he', 1234,
            style: 'currency',
            currency: 'ILS',
            notation: 'compact',
            compactDisplay: 'short'),
        '₪1.2K\u200F');
    expect(
        _ecmaFormatNumber('he', 1234,
            style: 'currency',
            currency: 'ILS',
            notation: 'compact',
            compactDisplay: 'long'),
        '₪1.2K\u200F');

    var compactSimple = intl.NumberFormat.compactSimpleCurrency(locale: 'he');
    expect(compactSimple.format(1234), '₪1.23K\u200F');
  });
}

String _ecmaFormatNumber(String locale, num number,
    {String? style,
    String? currency,
    String? notation,
    String? compactDisplay,
    int? maximumSignificantDigits,
    bool? useGrouping}) {
  final options = JSObject();
  if (notation != null) options['notation'] = notation.toJS;
  if (compactDisplay != null) {
    options['compactDisplay'] = compactDisplay.toJS;
  }
  if (style != null) options['style'] = style.toJS;
  if (currency != null) options['currency'] = currency.toJS;
  if (maximumSignificantDigits != null) {
    options['maximumSignificantDigits'] = maximumSignificantDigits.toJS;
  }
  if (useGrouping != null) {
    options['useGrouping'] = useGrouping.toJS;
  }
  return number.toJS.toLocaleString(locale, options);
}

var _unsupportedChromeLocales = [
  // Not supported in Chrome:
  'af', 'as', 'az', 'be', 'bm', 'br', 'bs', 'chr', 'cy', 'eu', 'fur', 'ga',
  'gl', 'gsw', 'haw', 'hy', 'is', 'ka', 'kk', 'km', 'ky', 'ln', 'lo', 'mg',
  'mk', 'mn', 'mt', 'my', 'ne', 'nyn', 'or', 'pa', 'si', 'sq', 'ur', 'uz', 'zu',
  'ps'
];

var _skipLocalesShort = [
  'it', // Expected: '7,7 Mio', actual: '7,7 Mln'
  'it-CH', // Expected: '7.7 Mio', actual: '7.7 Mln'
  'en-IN', // Expected: '4.3K', actual: '4.3T'.
  'en-ZA', // Expected: '4,3K', actual: '4.3K'.
  ..._unsupportedChromeLocales
];

var _skipLocalesLong = [
  'en-ZA', // Expected: '4,3 thousand', actual: '4.3 thousand'.
  'es-419', // Expected: '1.4 billones', actual: '1.4 billón'.
  'es-US', // Expected: '1.4 billones', actual: '1.4 billón'.
  'ml', // Expected: '1.1 ബില്യൺ', actual: '1.1 ലക്ഷം കോടി'.
  ..._unsupportedChromeLocales,
];

String _fixLocale(String locale) {
  return locale.replaceAll('_', '-');
}

void _validate(String locale, List<List<String>> expected) {
  _validateShort(_fixLocale(locale), expected);
  _validateLong(_fixLocale(locale), expected);
}

void _validateShort(String locale, List<List<String>> expected) {
  var skip = _skipLocalesShort.contains(locale)
      ? "Skipping problem locale '$locale' for SHORT compact number tests"
      : false;

  test('Validate $locale SHORT', () {
    for (var data in expected) {
      var number = num.parse(data.first);
      expect(
          _ecmaFormatNumber(
            locale,
            number,
            notation: 'compact',
            useGrouping: false,
          ),
          data[1]);
    }
  }, skip: skip);
}

void _validateLong(String locale, List<List<String>> expected) {
  var skip = _skipLocalesLong.contains(locale)
      ? "Skipping problem locale '$locale' for LONG compact number tests"
      : false;

  test('Validate $locale LONG', () {
    for (var data in expected) {
      var number = num.parse(data.first);
      expect(
          _ecmaFormatNumber(
            locale,
            number,
            notation: 'compact',
            compactDisplay: 'long',
            useGrouping: false,
          ),
          data[2]);
    }
  }, skip: skip);
}

void _validateMore(more_testdata.CompactRoundingTestCase t) {
  final options = JSObject();
  options['notation'] = 'compact'.toJS;
  if (t.maximumIntegerDigits != null) {
    options['maximumIntegerDigits'] = t.maximumIntegerDigits!.toJS;
  }

  if (t.minimumIntegerDigits != null) {
    options['minimumIntegerDigits'] = t.minimumIntegerDigits!.toJS;
  }

  if (t.maximumFractionDigits != null) {
    options['maximumFractionDigits'] = t.maximumFractionDigits!.toJS;
  }

  if (t.minimumFractionDigits != null) {
    options['minimumFractionDigits'] = t.minimumFractionDigits!.toJS;
  }

  if (t.minimumExponentDigits != null) {
    options['minimumExponentDigits'] = t.minimumExponentDigits!.toJS;
  }

  if (t.maximumSignificantDigits != null) {
    options['maximumSignificantDigits'] = t.maximumSignificantDigits!.toJS;
  }

  if (t.minimumSignificantDigits != null) {
    options['minimumSignificantDigits'] = t.minimumSignificantDigits!.toJS;
  }

  test(t.toString(), () {
    expect(
      t.number.toJS.toLocaleString('en-US', options),
      t.expected,
    );
  });
}
