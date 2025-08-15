// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'case_mapping.dart';
import 'collation.dart';
import 'display_names.dart';
import 'number_format.dart';
import 'src/case_mapping/case_mapping.dart' show buildCaseMapping;
import 'src/case_mapping/case_mapping_impl.dart';
import 'src/collation/collation.dart';
import 'src/collation/collation_impl.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/datetime_format/datetime_format_impl.dart';
import 'src/datetime_format/datetime_format_options.dart';
import 'src/display_names/display_names.dart';
import 'src/display_names/display_names_impl.dart';
import 'src/find_locale.dart';
import 'src/list_format/list_format.dart';
import 'src/list_format/list_format_impl.dart';
import 'src/list_format/list_format_options.dart';
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
///   locale: Locale(language: 'en', country: 'US'),
/// ).numberFormat;
/// print(numberFormat.percent().format(0.5)); //prints 50%
/// ```
class Intl {
  Locale locale;

  /// Construct an [Intl] instance providing the current [locale].
  Intl({Locale? locale}) : locale = locale ?? findSystemLocale();

  CaseMapping get caseMapping =>
      buildCaseMapping(CaseMappingImpl.build(locale));

  Collation collation([CollationOptions options = const CollationOptions()]) =>
      buildCollation(CollationImpl.build(locale, options));

  DateTimeFormatBuilder dateTimeFormat([
    DateTimeFormatOptions options = const DateTimeFormatOptions(),
  ]) => buildDateTimeFormat(DateTimeFormatImpl.build(locale, options));

  DisplayNames displayNames([
    DisplayNamesOptions options = const DisplayNamesOptions(),
  ]) => buildDisplayNames(DisplayNamesImpl.build(locale, options));

  ListFormat listFormat([
    ListFormatOptions options = const ListFormatOptions(),
  ]) => buildListFormat(ListFormatImpl.build(locale, options));

  NumberFormat numberFormat([NumberFormatOptions? options]) =>
      buildNumberFormat(
        NumberFormatImpl.build(locale, options ?? NumberFormatOptions.custom()),
      );

  PluralRules plural([PluralRulesOptions? options]) => buildPluralRules(
    PluralRulesImpl.build(locale, options ?? PluralRulesOptions()),
  );
}
