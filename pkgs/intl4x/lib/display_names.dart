// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Formatting names in different locales.
///
/// For a given [Locale], show the name of some information in that locale.
/// Provides several options as part of the [DisplayNames] constructor, such as
/// [Style], [LanguageDisplay], or [Fallback].
///
/// Languages:
/// ```dart
/// // Display the name of the language German in English
/// DisplayNames(locale: Locale.parse('en-US'))
///   .ofLanguage(Locale.parse('de-DE')); // German (Germany)
///
/// // Display the name of the language French in Chinese
/// DisplayNames(locale: Locale.parse('zh-Hant'))
///   .ofLanguage(Locale.parse('fr')); // 法文
/// ```
///
/// Regions:
/// ```dart
/// // Display the name of the region es-419, Latin America, in English
/// DisplayNames(locale: Locale.parse('en'))
///   .ofRegion('419'); // Latin America
///
/// // Display the name of the region Germany in Spanish
/// DisplayNames(locale: Locale.parse('es-419'))
///   .ofLanguage(Locale.parse('de')); // Alemania
/// ```
///
///
library;

import 'display_names.dart';

export 'src/display_names/display_names.dart' show DisplayNames;
export 'src/display_names/display_names_options.dart'
    show DateTimeField, DisplayType, Fallback, LanguageDisplay, Style;
export 'src/locale/locale.dart' show Locale;
