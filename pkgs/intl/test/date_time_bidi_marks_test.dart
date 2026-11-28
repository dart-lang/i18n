// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Tests for parsing Arabic dates typed without the right-to-left marks that
/// CLDR puts in the patterns, see dart-lang/i18n#852 and flutter/flutter#138635.
library;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

const _rlm = '\u200F';

void main() {
  setUpAll(initializeDateFormatting);

  // The date from flutter/flutter#138635, in Arabic-Indic digits.
  var date = DateTime(2023, 11, 16);

  group('typed without bidi marks', () {
    test('yMd, the code units from dart-lang/i18n#852', () {
      // Reported against intl 0.19, where `ar` still used Arabic-Indic digits.
      var typed = String.fromCharCodes([
        1633, 1633, 47, 1633, 1633, 47, 1634, 1632, 1632, 1633, //
      ]);
      var format = DateFormat('yMd', 'ar_EG');
      var expected = DateTime(2001, 11, 11);
      expect(format.parseStrict(typed), expected);
      expect(format.parse(typed), expected);
      expect(format.parseLoose(typed), expected);
    });

    test('yMd with Arabic-Indic digits (ar_EG)', () {
      var format = DateFormat.yMd('ar_EG');
      var typed = '١٦/١١/٢٠٢٣';
      expect(format.format(date), isNot(typed));
      expect(format.parseStrict(typed), date);
      expect(format.parse(typed), date);
      expect(format.parseLoose(typed), date);
    });

    test('yMd with Latin digits (ar)', () {
      var format = DateFormat.yMd('ar');
      expect(format.parseStrict('16/11/2023'), date);
      expect(format.tryParseStrict('16/11/2023'), date);
    });

    test('yM and Md', () {
      expect(DateFormat.yM('ar').parseStrict('11/2023'), DateTime(2023, 11));
      var md = DateFormat.Md('ar').parseStrict('16/11');
      expect([md.month, md.day], [11, 16]);
    });

    test('yMEd keeps the weekday and the comma', () {
      var format = DateFormat.yMEd('ar');
      var formatted = format.format(date);
      var typed = formatted.replaceAll(_rlm, '');
      expect(typed, isNot(formatted));
      expect(format.parseStrict(typed), date);
    });

    test('marks in only some of the places', () {
      var format = DateFormat.yMd('ar_EG');
      expect(format.parseStrict('١٦$_rlm/١١/٢٠٢٣'), date);
      expect(format.parseStrict('١٦/١١$_rlm/٢٠٢٣'), date);
    });
  });

  group('still strict about everything else', () {
    late DateFormat format;
    setUp(() => format = DateFormat.yMd('ar_EG'));

    test('wrong separator', () {
      expect(() => format.parseStrict('١٦-١١-٢٠٢٣'), throwsFormatException);
      expect(() => format.parseStrict('١٦ ١١ ٢٠٢٣'), throwsFormatException);
    });

    test('missing separator', () {
      expect(() => format.parseStrict('١٦/١١٢٠٢٣'), throwsFormatException);
      expect(() => format.parseStrict('١٦١١٢٠٢٣'), throwsFormatException);
    });

    test('invalid date and trailing characters', () {
      expect(() => format.parseStrict('٣١/١١/٢٠٢٣'), throwsFormatException);
      expect(() => format.parseStrict('١٦/١١/٢٠٢٣ '), throwsFormatException);
      expect(format.tryParseStrict('١٦/١١'), isNull);
    });
  });

  group('formatted output still parses', () {
    var patterns = ['yMd', 'yM', 'Md', 'yMEd', 'MEd'];
    for (var locale in ['ar', 'ar_EG', 'ar_SA']) {
      for (var pattern in patterns) {
        test('$pattern in $locale', () {
          var format = DateFormat(pattern, locale);
          var parsed = format.parseStrict(format.format(date));
          // Only the fields that the pattern has are parsed.
          expect(parsed.month, 11);
          if (pattern.contains('d')) expect(parsed.day, 16);
          if (pattern.contains('y')) expect(parsed.year, 2023);
        });
      }
    }
  });
}
