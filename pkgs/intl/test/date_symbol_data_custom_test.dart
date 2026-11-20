// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_local.dart' as local_symbols;
import 'package:intl/date_time_patterns.dart' as local_patterns;
import 'package:test/test.dart';

void main() {
  test('a locale that does not match symbols.NAME names the locale', () {
    final symbols = local_symbols.dateTimeSymbolMap()['fr'];
    final patterns = local_patterns.dateTimePatternMap()['fr'];

    expect(
      () => initializeDateFormattingCustom(
        locale: 'de',
        symbols: symbols,
        patterns: patterns,
      ),
      throwsA(
        isA<ArgumentError>()
            .having((e) => e.name, 'name', 'locale')
            .having(
              (e) => e.message,
              'message',
              'Locale does not match symbols.NAME',
            ),
      ),
    );
  });
}
