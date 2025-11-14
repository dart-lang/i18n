// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:test/test.dart';

import 'datetime_format_conformance_data/d.g.dart';
import 'datetime_format_conformance_data/m.g.dart';
import 'datetime_format_conformance_data/md.g.dart';
import 'datetime_format_conformance_data/mdt.g.dart';
import 'datetime_format_conformance_data/t.g.dart';
import 'datetime_format_conformance_data/ymd.g.dart';
import 'datetime_format_conformance_data/ymde.g.dart';
import 'datetime_format_conformance_data/ymdet.g.dart';
import 'datetime_format_conformance_data/ymdt.g.dart';

import 'utils.dart';

void main() {
  testFormatter('ymdet', ymdetOptions, DateTimeFormat.ymdet);
  testFormatter('ymdt', ymdtOptions, DateTimeFormat.ymdt);
  testFormatter(
    'ymde',
    ymdeOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.ymde(
          locale: locale,
          alignment: alignment,
          length: length,
          yearStyle: yearStyle,
        ),
  );
  testFormatter(
    'ymd',
    ymdOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.ymd(
          locale: locale,
          alignment: alignment,
          length: length,
          yearStyle: yearStyle,
        ),
  );
  testFormatter(
    'mdt',
    mdtOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.mdt(
          locale: locale,
          alignment: alignment,
          length: length,
          timePrecision: timePrecision,
        ),
  );
  testFormatter(
    'md',
    mdOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.md(locale: locale, alignment: alignment, length: length),
  );
  testFormatter(
    'm',
    mOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.m(locale: locale, alignment: alignment, length: length),
  );
  testFormatter(
    'd',
    dOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) =>
        DateTimeFormat.d(locale: locale, alignment: alignment, length: length),
  );
  testFormatter(
    't',
    tOptions,
    ({locale, alignment, length, timePrecision, yearStyle}) => DateTimeFormat.t(
      locale: locale,
      alignment: alignment,
      length: length,
      timePrecision: timePrecision,
    ),
  );
}

final dateTime = DateTime(2025, 6, 8, 14, 30, 45, 123);

void testFormatter(
  String type,
  Map<
    String,
    Map<
      (TimePrecision?, DateTimeLength?, DateTimeAlignment?, YearStyle?),
      String
    >
  >
  options,
  DateTimeFormatter Function({
    Locale? locale,
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
    TimePrecision? timePrecision,
  })
  formatter,
) {
  for (final locale in ['en-US', 'de-DE']) {
    final option = options[locale]!;
    group('all options $type $locale', () {
      for (final precision in [...TimePrecision.values, null]) {
        for (final length in [...DateTimeLength.values, null]) {
          for (final alignment in [...DateTimeAlignment.values, null]) {
            for (final yearStyle in [
              ...YearStyle.values,
              null,
            ]..removeWhere((element) => element == YearStyle.withEra)) {
              testWithFormatting(
                '($precision, $length, $alignment, $yearStyle)',
                () {
                  final format = formatter(
                    locale: Locale.parse(locale),
                    length: length,
                    alignment: alignment,
                    yearStyle: yearStyle,
                    timePrecision: precision,
                  ).format(dateTime);
                  expect(
                    format.replaceAll(RegExp(r'\s'), ' '),
                    option[(precision, length, alignment, yearStyle)]!
                        .replaceAll(RegExp(r'\s'), ' '),
                  );
                },
              );
            }
          }
        }
      }
    });
  }
}
