// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'collation.dart';
import 'display_names.dart';
import 'number_format.dart';
import 'src/collation/collation.dart';
import 'src/collation/collation_impl.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/datetime_format/datetime_format_impl.dart';
import 'src/datetime_format/datetime_format_options.dart';
import 'src/display_names/display_names.dart';
import 'src/display_names/display_names_impl.dart';
import 'src/ecma/ecma_policy.dart';
import 'src/ecma/ecma_stub.dart' if (dart.library.js) 'src/ecma/ecma_web.dart';
import 'src/find_locale.dart';
import 'src/list_format/list_format.dart';
import 'src/list_format/list_format_impl.dart';
import 'src/list_format/list_format_options.dart';
import 'src/locale/locale.dart';
import 'src/number_format/number_format.dart';
import 'src/number_format/number_format_impl.dart';
import 'src/plural_rules/plural_rules.dart';
import 'src/plural_rules/plural_rules_impl.dart';
import 'src/plural_rules/plural_rules_options.dart';

export 'src/locale/locale.dart';
export 'src/plural_rules/plural_rules.dart' show PluralCategory, PluralRules;

typedef Icu4xKey = String;

/// The main class for all i18n calls, containing references to other
/// functions such as
/// * [numberFormat]
///
/// The functionalities are called through getters on an `Intl` instance, i.e.
/// ```dart
/// final numberFormat = Intl(
///   ecmaPolicy: const AlwaysEcma(),
///   locale: Locale(language: 'en', country: 'US'),
/// ).numberFormat;
/// print(numberFormat.percent().format(0.5)); //prints 50%
/// ```
class Intl {
  final EcmaPolicy ecmaPolicy;
  final LocaleMatcher localeMatcher;

  Collation collation([CollationOptions options = const CollationOptions()]) =>
      buildCollation(
        CollationImpl.build(locale, options, localeMatcher, ecmaPolicy),
      );

  NumberFormat numberFormat([NumberFormatOptions? options]) =>
      buildNumberFormat(
        NumberFormatImpl.build(
          locale,
          options ?? NumberFormatOptions.custom(),
          localeMatcher,
          ecmaPolicy,
        ),
      );

  ListFormat listFormat([
    ListFormatOptions options = const ListFormatOptions(),
  ]) => buildListFormat(
    ListFormatImpl.build(locale, options, localeMatcher, ecmaPolicy),
  );

  DisplayNames displayNames([
    DisplayNamesOptions options = const DisplayNamesOptions(),
  ]) => buildDisplayNames(
    DisplayNamesImpl.build(locale, options, localeMatcher, ecmaPolicy),
  );

  DateTimeFormat dateTimeFormat([
    DateTimeFormatOptions options = const DateTimeFormatOptions(),
  ]) => buildDateTimeFormat(
    DateTimeFormatImpl.build(locale, options, localeMatcher, ecmaPolicy),
  );

  PluralRules plural([PluralRulesOptions? options]) => buildPluralRules(
    PluralRulesImpl.build(
      locale,
      options ?? PluralRulesOptions(),
      localeMatcher,
      ecmaPolicy,
    ),
  );

  /// Construct an [Intl] instance providing the current [locale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    Locale? locale,
    this.ecmaPolicy = defaultPolicy,
    this.localeMatcher = LocaleMatcher.lookup,
  }) : locale = locale ?? findSystemLocale();

  Intl.includeLocales({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> includedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(locale: locale, ecmaPolicy: ecmaPolicy);

  Intl.excludeLocales({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(locale: locale, ecmaPolicy: ecmaPolicy);

  Intl({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(locale: locale, ecmaPolicy: ecmaPolicy);

  Locale locale;

  /// Whether to use the browser with the current settings
  bool get useEcma {
    final shouldUse = ecmaPolicy.useBrowser(locale);
    final canUse = true;
    return shouldUse && canUse;
  }
}
