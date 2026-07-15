// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl4x/display_names.dart';

void main() {
  // #region display_names_languages
  // Display the name of the language German in English
  final germanInEnglish = DisplayNames(
    locale: Locale.parse('en-US'),
  ).ofLocale(Locale.parse('de-DE'));
  print(germanInEnglish); // German (Germany)
  // #endregion display_names_languages

  // #region display_names_regions
  // Display the name of the region Germany in Spanish
  final germanyInSpanish = DisplayNames(
    locale: Locale.parse('es-419'),
  ).ofRegion('DE');
  print(germanyInSpanish); // Alemania
  // #endregion display_names_regions
}
