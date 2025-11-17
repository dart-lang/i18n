// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main(List<String> arguments) async {
  // These examples were all run with locale en_US.

  String? locale = 'en_US';
  await initializeDateFormatting(locale);
  final numberFormatters = [
    NumberFormat.compact(locale: locale), // 2M
    NumberFormat.compactCurrency(locale: locale), // USD2M
    NumberFormat.compactLong(locale: locale), // 2 million
    NumberFormat.compactSimpleCurrency(locale: locale), // $2M
    NumberFormat.currency(locale: locale), // USD2,000,000.33
    NumberFormat.decimalPattern(locale), // 2,000,000.335
    NumberFormat.decimalPatternDigits(decimalDigits: 2), // 2,000,000.33
    NumberFormat.decimalPercentPattern(decimalDigits: 1), // 200,000,033.5%
    NumberFormat.percentPattern(locale), // 200,000,033%
    NumberFormat.scientificPattern(locale), // 2E6
    NumberFormat.simpleCurrency(locale: locale), // $2,000,000.33
  ];
  print('Number formatting:');
  for (final formatter in numberFormatters) {
    print(formatter.format(2000000.33454));
  }

  final dateFormatters = [
    DateFormat.d(locale), // 26
    DateFormat.E(locale), // Wed
    DateFormat.EEEE(locale), // Wednesday
    DateFormat.EEEEE(locale), // W
    DateFormat.LLL(locale), // Apr
    DateFormat.LLLL(locale), // April
    DateFormat.M(locale), // 4
    DateFormat.Md(locale), // 4/26
    DateFormat.MEd(locale), // Wed, 4/26
    DateFormat.MMM(locale), // Apr
    DateFormat.MMMd(locale), // Apr 26
    DateFormat.MMMEd(locale), // Wed, Apr 26
    DateFormat.MMMM(locale), // April
    DateFormat.MMMMd(locale), // April 26
    DateFormat.MMMMEEEEd(locale), // Wednesday, April 26
    DateFormat.QQQ(locale), // Q2
    DateFormat.QQQQ(locale), // 2nd quarter
    DateFormat.y(locale), // 2023
    DateFormat.yM(locale), // 4/2023
    DateFormat.yMd(locale), // 4/26/2023
    DateFormat.yMEd(locale), // Wed, 4/26/2023
    DateFormat.yMMM(locale), // Apr 2023
    DateFormat.yMMMd(locale), // Apr 26, 2023
    DateFormat.yMMMEd(locale), // Wed, Apr 26, 2023
    DateFormat.yMMMM(locale), // April 2023
    DateFormat.yMMMMd(locale), // April 26, 2023
    DateFormat.yMMMMEEEEd(locale), // Wednesday, April 26, 2023
    DateFormat.yQQQ(locale), // Q2 2023
    DateFormat.yQQQQ(locale), // 2nd quarter 2023
    DateFormat.H(locale), // 05
    DateFormat.Hm(locale), // 05:24
    DateFormat.Hms(locale), // 05:24:22
    DateFormat.j(locale), // 5 AM
    DateFormat.jm(locale), // 5:24 AM
    DateFormat.jms(locale), // 5:24:22 AM
  ];
  print('Date formatting:');
  for (final formatter in dateFormatters) {
    print(formatter.format(DateTime(2023, 4, 26, 5, 24, 22, 1, 5)));
  }
}
