// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'collation.dart';
import 'display_names.dart';
import 'number_format.dart';
import 'src/case_mapping/case_mapping.dart';
import 'src/case_mapping/case_mapping_impl.dart';
import 'src/collation/collation_impl.dart';
import 'src/data.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/datetime_format/datetime_format_impl.dart';
import 'src/datetime_format/datetime_format_options.dart';
import 'src/display_names/display_names_impl.dart';
import 'src/ecma/ecma_policy.dart';
import 'src/ecma/ecma_stub.dart' if (dart.library.js) 'src/ecma/ecma_web.dart';
import 'src/find_locale.dart';
import 'src/list_format/list_format.dart';
import 'src/list_format/list_format_impl.dart';
import 'src/list_format/list_format_options.dart';
import 'src/locale/locale.dart';
import 'src/number_format/number_format_impl.dart';
import 'src/plural_rules/plural_rules.dart';
import 'src/plural_rules/plural_rules_impl.dart';
import 'src/plural_rules/plural_rules_options.dart';

export 'src/data.dart';
export 'src/locale/locale.dart';
export 'src/plural_rules/plural_rules.dart';

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
  final Data data;
  final List<Locale> supportedLocales;
  final LocaleMatcher localeMatcher;

  Collation collation([CollationOptions options = const CollationOptions()]) =>
      Collation(
        CollationImpl.build(locale, data, options, localeMatcher, ecmaPolicy),
      );

  NumberFormat numberFormat([NumberFormatOptions? options]) => NumberFormat(
        NumberFormatImpl.build(locale, data,
            options ?? NumberFormatOptions.custom(), localeMatcher, ecmaPolicy),
      );

  ListFormat listFormat(
          [ListFormatOptions options = const ListFormatOptions()]) =>
      ListFormat(
        ListFormatImpl.build(locale, data, options, localeMatcher, ecmaPolicy),
      );

  DisplayNames displayNames(
          [DisplayNamesOptions options = const DisplayNamesOptions()]) =>
      DisplayNames(
        DisplayNamesImpl.build(
            locale, data, options, localeMatcher, ecmaPolicy),
      );

  DateTimeFormat datetimeFormat(
          [DateTimeFormatOptions options = const DateTimeFormatOptions()]) =>
      DateTimeFormat(
        DateTimeFormatImpl.build(
            locale, data, options, localeMatcher, ecmaPolicy),
      );

  PluralRules plural([PluralRulesOptions? options]) => PluralRules(
        PluralRulesImpl.build(locale, data, options ?? PluralRulesOptions(),
            localeMatcher, ecmaPolicy),
      );

  CaseMapping get caseMapping => CaseMapping(
      CaseMappingImpl.build(locale, data, localeMatcher, ecmaPolicy));

  /// Construct an [Intl] instance providing the current [locale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    Locale? locale,
    this.ecmaPolicy = defaultPolicy,
    this.supportedLocales = allLocales,
    this.localeMatcher = LocaleMatcher.lookup,
    this.data = const NoData(),
  }) : locale = locale ?? findSystemLocale();

  Intl.includeLocales({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> includedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          locale: locale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: includedLocales,
        );

  Intl.excludeLocales({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> excludedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          locale: locale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: allLocales
              .where((locale) => !excludedLocales.contains(locale))
              .toList(),
        );

  Intl({
    Locale? locale,
    EcmaPolicy ecmaPolicy = defaultPolicy,
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
    Data data = const BundleData(),
  }) : this._(
          locale: locale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: allLocales,
          data: data,
        );

  Locale locale;

  /// Whether to use the browser with the current settings
  bool get useEcma {
    final shouldUse = ecmaPolicy.useBrowser(locale);
    final canUse = true;
    return shouldUse && canUse;
  }
}
