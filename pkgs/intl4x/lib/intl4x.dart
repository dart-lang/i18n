// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/collator/collator.dart';
import 'src/collator/collator_4x.dart';
import 'src/collator/collator_stub.dart'
    if (dart.library.js) 'src/collator/collator_ecma.dart';
import 'src/data.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/datetime_format/datetime_format_4x.dart';
import 'src/datetime_format/datetime_format_stub.dart'
    if (dart.library.js) 'src/datetime_format/datetime_format_ecma.dart';
import 'src/ecma/ecma_policy.dart';
import 'src/ecma/ecma_stub.dart' if (dart.library.js) 'src/ecma/ecma_web.dart';
import 'src/list_format/list_format.dart';
import 'src/list_format/list_format_4x.dart';
import 'src/list_format/list_format_stub.dart'
    if (dart.library.js) 'src/list_format/list_format_ecma.dart';
import 'src/locales.dart';
import 'src/number_format/number_format.dart';
import 'src/number_format/number_format_4x.dart';
import 'src/number_format/number_format_stub.dart'
    if (dart.library.js) 'src/number_format/number_format_ecma.dart';

export 'src/datetime_format/datetime_format_options.dart';
export 'src/ecma/ecma_policy.dart';
export 'src/list_format/list_format_options.dart';
export 'src/number_format/number_format_options.dart';

typedef Icu4xKey = String;
typedef Locale = String;

/// The main class for all i18n calls, containing references to other
/// functions such as
/// * [NumberFormat]
/// * [DatetimeFormat]
/// * [ListFormat]
/// * [Collator].
///
/// The functionalities are called through getters on an `Intl` instance, i.e.
/// ```dart
/// final numberFormat = Intl(
///   ecmaPolicy: const AlwaysEcma(),
///   locale: 'en_US',
/// ).numberFormat;
/// print(numberFormat.percent().format(0.5)); //prints 50%
/// ```
class Intl {
  final EcmaPolicy ecmaPolicy;

  // ignore: unused_field, prefer_final_fields
  String _dyliblocation = 'path.dll'; //What about path.wasm? How to load this?
  // ignore: unused_field, prefer_final_fields
  String _datalocation = 'data.blob'; //What about additional data?

  final List<Locale> locales;

  late NumberFormat numberFormat;
  late DatetimeFormat datetimeFormat;
  late ListFormat listFormat;
  late Collator collation;

  /// Construct an [Intl] instance providing the current [locale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    String locale = 'en',
    this.ecmaPolicy = defaultPolicy,
    this.locales = allLocales,
  }) : _locale = locale {
    setFormatters(locale);
    icu4xDataKeys.addAll(getInitialICU4XDataKeys());
  }

  Intl.includeLocales({
    String defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> includedLocales = const [],
  }) : this._(
          locale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          locales: includedLocales,
        );

  Intl.excludeLocales({
    String defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> excludedLocales = const [],
  }) : this._(
          locale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          locales: allLocales
              .where((locale) => !excludedLocales.contains(locale))
              .toList(),
        );

  Intl({
    String defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
  }) : this._(
          locale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          locales: allLocales,
        );

  void setFormatters(String locale) {
    if (useEcma) {
      numberFormat = getNumberFormatter(locale);
      datetimeFormat = getDatetimeFormatter(locale);
      listFormat = getListFormatter(locale);
      collation = getCollator(locale);
    } else {
      numberFormat = getNumberFormatter4X(locale);
      datetimeFormat = getDatetimeFormatter4X(locale);
      listFormat = getListFormatter4X(locale);
      collation = getCollator4X(locale);
    }
  }

  String _locale;

  String get locale => _locale;

  set locale(String value) {
    _locale = value;
    setFormatters(locale);
  }

  /// The set of available locales, either through
  Set<String> get availableLocales => {
        ...ecmaPolicy.locales,
        ...icu4xDataKeys.keys,
      };

  /// The ICU4X data for each of the locales. The exact data structure is yet
  /// to be determined.
  final Map<String, List<Icu4xKey>> icu4xDataKeys = {};

  void addIcu4XData(Data data) {
    var callbackFromICUTellingMeWhatLocalesTheDataContained =
        extractKeysFromData();
    icu4xDataKeys.addAll(callbackFromICUTellingMeWhatLocalesTheDataContained);
    throw UnimplementedError('Call to ICU4X here');
  }

  Map<String, List<Icu4xKey>> extractKeysFromData() {
    //TODO: Add implementation
    return {};
  }

  Map<String, List<Icu4xKey>> getInitialICU4XDataKeys() {
    //TODO: Add implementation
    return {};
  }

  /// Whether to use the browser with the current settings
  bool get useEcma =>
      ecmaPolicy is AlwaysEcma ||
      (ecmaPolicy is SometimesEcma &&
          (ecmaPolicy as SometimesEcma).useForLocales.contains(locale));
}
