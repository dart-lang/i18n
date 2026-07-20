// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/plural_rules.dart';

void main() {
  // #region plural_rules
  final rules = PluralRules(locale: Locale.parse('en-US'));
  print(rules.select(2, one: 'message', other: 'messages')); // messages
  print(rules.select(1, one: 'message', other: 'messages')); // message
  print(rules.select(0, one: 'message', other: 'messages')); // messages
  // #endregion plural_rules
}
