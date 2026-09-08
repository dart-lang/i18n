// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/display_names.dart';

void main() {
  // #region display_names_languages
  // Display the name of the language German in English
  final germanNames = DisplayNames(locale: Locale.parse('en-US'));
  print(germanNames.ofLocale(Locale.parse('de-DE'))); // German (Germany)
  // #endregion display_names_languages

  // #region display_names_regions
  // Display the name of the region Germany in Spanish
  final spanishNames = DisplayNames(locale: Locale.parse('es-419'));
  print(spanishNames.ofRegion('DE')); // Alemania
  // #endregion display_names_regions
}
