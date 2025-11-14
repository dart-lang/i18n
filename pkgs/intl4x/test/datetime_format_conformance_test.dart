// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/datetime_format.dart';
import 'package:test/test.dart';

import 'datetime_format_conformance_data/d.dart' show dOptions;
import 'datetime_format_conformance_data/m.dart' show mOptions;
import 'datetime_format_conformance_data/md.dart' show mdOptions;
import 'datetime_format_conformance_data/mdt.dart' show mdtOptions;
import 'datetime_format_conformance_data/t.dart' show tOptions;
import 'datetime_format_conformance_data/ymd.dart';
import 'datetime_format_conformance_data/ymde.dart' show ymdeOptions;
import 'datetime_format_conformance_data/ymdet.dart';
import 'datetime_format_conformance_data/ymdt.dart' show ymdtOptions;
import 'utils.dart';

void main() {
  final dateTimeFormat = DateTimeFormat(locale: Locale.parse('de-DE'));

  testFormatter('ymdet', ymdetOptions, dateTimeFormat.ymdet);
  testFormatter('ymdt', ymdtOptions, dateTimeFormat.ymdt);
  testFormatter(
    'ymde',
    ymdeOptions,
    ({alignment, length, timePrecision, yearStyle}) => dateTimeFormat.ymde(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
    ),
  );
  testFormatter(
    'ymd',
    ymdOptions,
    ({alignment, length, timePrecision, yearStyle}) => dateTimeFormat.ymd(
      alignment: alignment,
      length: length,
      yearStyle: yearStyle,
    ),
  );
  testFormatter(
    'mdt',
    mdtOptions,
    ({alignment, length, timePrecision, yearStyle}) => dateTimeFormat.mdt(
      alignment: alignment,
      length: length,
      timePrecision: timePrecision,
    ),
  );
  testFormatter(
    'md',
    mdOptions,
    ({alignment, length, timePrecision, yearStyle}) =>
        dateTimeFormat.md(alignment: alignment, length: length),
  );
  testFormatter(
    'm',
    mOptions,
    ({alignment, length, timePrecision, yearStyle}) =>
        dateTimeFormat.m(alignment: alignment, length: length),
  );
  testFormatter(
    'd',
    dOptions,
    ({alignment, length, timePrecision, yearStyle}) =>
        dateTimeFormat.d(alignment: alignment, length: length),
  );
  testFormatter(
    't',
    tOptions,
    ({alignment, length, timePrecision, yearStyle}) => dateTimeFormat.t(
      alignment: alignment,
      length: length,
      timePrecision: timePrecision,
    ),
  );
}

void testFormatter(
  String type,
  Map<(TimePrecision?, DateTimeLength?, DateTimeAlignment?, YearStyle?), String>
  options,
  DateTimeFormatter Function({
    DateTimeAlignment? alignment,
    DateTimeLength? length,
    YearStyle? yearStyle,
    TimePrecision? timePrecision,
  })
  formatter,
) {
  group('all options $type', () {
    final dateTime = DateTime(2025, 6, 8, 14, 30, 45, 123);
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
                  length: length,
                  alignment: alignment,
                  yearStyle: yearStyle,
                  timePrecision: precision,
                ).format(dateTime);
                expect(
                  format,
                  options[(precision, length, alignment, yearStyle)],
                );
              },
            );
          }
        }
      }
    }
  });
}
