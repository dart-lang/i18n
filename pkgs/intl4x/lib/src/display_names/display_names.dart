// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../find_locale.dart' show findSystemLocale;
import '../locale/locale.dart' show Locale;
import '../test_checker.dart';
import 'display_names_impl.dart';
import 'display_names_options.dart';

/// Provides localized names for languages, regions, scripts, and currencies.
///
/// This class uses the specified locale and options to format codes (like 'en',
///  'US') into human-readable strings (like 'English', 'United States').
class DisplayNames {
  final DisplayNamesImpl _impl;

  /// Creates a new display name formatter configured for a specific locale.
  ///
  /// * [locale]: The locale whose language is used to format the names. If
  ///   `null`, the system's current locale is used.
  /// * [style]: The desired length of the name, e.g., [Style.long] ('United
  ///   States') or [Style.short] ('US'). Defaults to [Style.long].
  /// * [languageDisplay]: Controls how language names are displayed, e.g.,
  ///   including the dialect or region. Defaults to [LanguageDisplay.dialect].
  /// * [fallback]: Specifies the behavior if a display name is not available
  ///   for a code. Defaults to [Fallback.code], which returns the input code
  ///   itself.
  DisplayNames({
    Locale? locale,
    Style style = Style.long,
    LanguageDisplay languageDisplay = LanguageDisplay.dialect,
    Fallback fallback = Fallback.code,
  }) : _impl = DisplayNamesImpl.build(
         locale ?? findSystemLocale(),
         DisplayNamesOptions(
           style: style,
           languageDisplay: languageDisplay,
           fallback: fallback,
         ),
       );

  /// Returns the localized display name for a given language [locale].
  ///
  /// The resulting name is formatted according to the options configured in the
  /// constructor.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/display_names.dart';
  ///
  /// void main() {
  ///   print(DisplayNames.ofLocale(Locale.parse('de'))); // Prints 'German'
  /// }
  /// ```
  String ofLocale(Locale locale) => _of(locale, _impl.ofLocale);

  /// Returns the localized display name for a given **region** code.
  ///
  /// The resulting name is formatted according to the options configured in the
  /// constructor.
  ///
  /// Example:
  /// ```dart
  /// import 'package:intl4x/display_names.dart';
  ///
  /// void main() {
  ///   print(DisplayNames.ofRegion('DE')); // Prints 'Germany'
  /// }
  /// ```
  String ofRegion(String regionCode) => _of(regionCode, _impl.ofRegion);

  String _of<T>(T object, String Function(T field) implementation) {
    if (isInTest) {
      return '$object//${_impl.locale}';
    } else {
      return implementation(object);
    }
  }
}
