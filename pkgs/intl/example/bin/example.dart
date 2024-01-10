// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';

void main(List<String> arguments) {
  // These examples were all run with locale en_US.

  final numberFormatters = [
    NumberFormat.compact(), // 2M
    NumberFormat.compactCurrency(), // USD2M
    NumberFormat.compactLong(), // 2 million
    NumberFormat.compactSimpleCurrency(), // $2M
    NumberFormat.currency(), // USD2,000,000.33
    NumberFormat.decimalPattern(), // 2,000,000.335
    NumberFormat.decimalPatternDigits(decimalDigits: 2), // 2,000,000.33
    NumberFormat.decimalPercentPattern(decimalDigits: 1), // 200,000,033.5%
    NumberFormat.percentPattern(), // 200,000,033%
    NumberFormat.scientificPattern(), // 2E6
    NumberFormat.simpleCurrency(), // $2,000,000.33
  ];
  print('Number formatting:');
  for (final formatter in numberFormatters) {
    print(formatter.format(2000000.33454));
  }

  final dateFormatters = [
    DateFormat.d(), // 26
    DateFormat.E(), // Wed
    DateFormat.EEEE(), // Wednesday
    DateFormat.EEEEE(), // W
    DateFormat.LLL(), // Apr
    DateFormat.LLLL(), // April
    DateFormat.M(), // 4
    DateFormat.Md(), // 4/26
    DateFormat.MEd(), // Wed, 4/26
    DateFormat.MMM(), // Apr
    DateFormat.MMMd(), // Apr 26
    DateFormat.MMMEd(), // Wed, Apr 26
    DateFormat.MMMM(), // April
    DateFormat.MMMMd(), // April 26
    DateFormat.MMMMEEEEd(), // Wednesday, April 26
    DateFormat.QQQ(), // Q2
    DateFormat.QQQQ(), // 2nd quarter
    DateFormat.y(), // 2023
    DateFormat.yM(), // 4/2023
    DateFormat.yMd(), // 4/26/2023
    DateFormat.yMEd(), // Wed, 4/26/2023
    DateFormat.yMMM(), // Apr 2023
    DateFormat.yMMMd(), // Apr 26, 2023
    DateFormat.yMMMEd(), // Wed, Apr 26, 2023
    DateFormat.yMMMM(), // April 2023
    DateFormat.yMMMMd(), // April 26, 2023
    DateFormat.yMMMMEEEEd(), // Wednesday, April 26, 2023
    DateFormat.yQQQ(), // Q2 2023
    DateFormat.yQQQQ(), // 2nd quarter 2023
    DateFormat.H(), // 05
    DateFormat.Hm(), // 05:24
    DateFormat.Hms(), // 05:24:22
    DateFormat.j(), // 5 AM
    DateFormat.jm(), // 5:24 AM
    DateFormat.jms(), // 5:24:22 AM
  ];
  print('Date formatting:');
  for (final formatter in dateFormatters) {
    print(formatter.format(DateTime(2023, 4, 26, 5, 24, 22, 1, 5)));
  }
}
