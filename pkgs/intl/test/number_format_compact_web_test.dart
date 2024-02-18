// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('browser')
// Tests for compact number formatting in pure Dart and in ECMAScript.
//
// TODO(b/36488375): run all these tests against both implementations to prove
// consistency when the bug is fixed. Also fix documentation and perhaps
// merge tests: these tests currently also touch non-compact currency
// formatting.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:intl/intl.dart' as intl;
import 'package:test/test.dart';

import 'compact_number_test_data.dart' as testdata;
import 'more_compact_number_test_data.dart' as more_testdata;

void main() {
  testdata.compactNumberTestData.forEach(_validate);
  more_testdata.cldr35CompactNumTests.forEach(_validateMore);

  test('RTL currency formatting', () {
    var basic = intl.NumberFormat.currency(locale: 'he');
    expect(basic.format(1234), '\u200F1,234.00\u00A0\u200FILS');
    basic = intl.NumberFormat.currency(locale: 'he', symbol: '₪');
    expect(basic.format(1234), '\u200F1,234.00\u00A0\u200F₪');
    expect(_ecmaFormatNumber('he', 1234.toJS, style: 'currency', currency: 'ILS'),
        '\u200F1,234.00\u00A0\u200F₪');

    var compact = intl.NumberFormat.compactCurrency(locale: 'he');
    expect(compact.format(1234), 'ILS1.23K\u200F');
    compact = intl.NumberFormat.compactCurrency(locale: 'he', symbol: '₪');
    expect(compact.format(1234), '₪1.23K\u200F');
    // ECMAScript skips the RTL character for notation:'compact':
    expect(
        _ecmaFormatNumber('he', 1234.toJS,
            style: 'currency', currency: 'ILS', notation: 'compact'),
        '₪1.2K\u200F');
    // short/long compactDisplay doesn't change anything here:
    expect(
        _ecmaFormatNumber('he', 1234.toJS,
            style: 'currency',
            currency: 'ILS',
            notation: 'compact',
            compactDisplay: 'short'),
        '₪1.2K\u200F');
    expect(
        _ecmaFormatNumber('he', 1234.toJS,
            style: 'currency',
            currency: 'ILS',
            notation: 'compact',
            compactDisplay: 'long'),
        '₪1.2K\u200F');

    var compactSimple = intl.NumberFormat.compactSimpleCurrency(locale: 'he');
    expect(compactSimple.format(1234), '₪1.23K\u200F');
  });
}

@JSExport()
class FakeEcmaNumberFormat {
  String? notation;
  String? compactDisplay;
  String? style;
  String? currency;
  int? minimumIntegerDigits;
  int? maximumIntegerDigits;
  int? minimumSignificantDigits;
  int? maximumSignificantDigits;
  int? minimumFractionDigits;
  int? maximumFractionDigits;
  int? minimumExponentDigits;
  bool? useGrouping;
}

extension type EcmaFormatNumbe(JSObject _) implements JSObject {
  external String? notation;
  external String? compactDisplay;
  external String? style;
  external String? currency;
  external int? minimumIntegerDigits;
  external int? maximumIntegerDigits;
  external int? minimumSignificantDigits;
  external int? maximumSignificantDigits;
  external int? minimumFractionDigits;
  external int? maximumFractionDigits;
  external int? minimumExponentDigits;
  external bool? useGrouping;
}

String _ecmaFormatNumber(String locale, JSNumber number,
    {String? style,
    String? currency,
    String? notation,
    String? compactDisplay,
    int? maximumSignificantDigits,
    bool? useGrouping}) {
  var options = FakeEcmaNumberFormat();
  if (notation != null) options.notation = notation;
  if (compactDisplay != null) {
    options.compactDisplay = compactDisplay;
  }
  if (style != null) options.style = style;
  if (currency != null) options.currency = currency;
  if (maximumSignificantDigits != null) {
    options.maximumSignificantDigits = maximumSignificantDigits;
  }
  if (useGrouping != null) options.useGrouping = useGrouping;
  return number.callMethod('toLocaleString', [locale, options]);
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
  'en-ZA', // Expected: '4.3K', actual: '4,3K'.
  ..._unsupportedChromeLocales
];

var _skipLocalesLong = [
  'en-ZA', // Expected: '4.3 thousand', actual: '4,3 thousand'.
  'zh-HK', // Expected: '4.3K', actual: '4321'.
  ..._unsupportedChromeLocales
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
            number.toJS,
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
            number.toJS,
            notation: 'compact',
            compactDisplay: 'long',
            useGrouping: false,
          ),
          data[2]);
    }
  }, skip: skip);
}

void _validateMore(more_testdata.CompactRoundingTestCase t) {
  var options = FakeEcmaNumberFormat();
  options.notation = 'compact';
  if (t.maximumIntegerDigits != null) {
    options.maximumIntegerDigits = t.maximumIntegerDigits;
  }

  if (t.minimumIntegerDigits != null) {
    options.minimumIntegerDigits = t.minimumIntegerDigits;
  }

  if (t.maximumFractionDigits != null) {
    options.maximumFractionDigits = t.maximumFractionDigits;
  }

  if (t.minimumFractionDigits != null) {
    options.minimumFractionDigits = t.minimumFractionDigits;
  }

  if (t.minimumExponentDigits != null) {
    options.minimumExponentDigits = t.minimumExponentDigits;
  }

  if (t.maximumSignificantDigits != null) {
    options.maximumSignificantDigits = t.maximumSignificantDigits;
  }

  if (t.minimumSignificantDigits != null) {
    options.minimumSignificantDigits = t.minimumSignificantDigits;
  }

  test(t.toString(), () {
    expect(
      t.number.callMethod('toLocaleString', ['en-US', options]),
      t.expected,
    );
  });
}
