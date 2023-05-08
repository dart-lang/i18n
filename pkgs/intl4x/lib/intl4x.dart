// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'src/collator/collator.dart' as collator;
import 'src/data.dart';
import 'src/datetime_format/datetime_format.dart' as datetime_format;
import 'src/ecma/ecma_policy.dart';
import 'src/ecma/ecma_stub.dart' if (dart.library.js) 'src/ecma/ecma_web.dart';
import 'src/list_format/list_format.dart' as list_format;
import 'src/locale.dart';
import 'src/number_format/number_format.dart' as number_format;
import 'src/options.dart';

export 'src/datetime_format/datetime_format_options.dart';
export 'src/ecma/ecma_policy.dart';
export 'src/list_format/list_format_options.dart';
export 'src/number_format/number_format_options.dart';

typedef Icu4xKey = String;

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
  final LocaleMatcher localeMatcher;

  late number_format.NumberFormat numberFormat;
  late datetime_format.DatetimeFormat datetimeFormat;
  late list_format.ListFormat listFormat;
  late collator.Collator collation;

  /// Construct an [Intl] instance providing the current [locale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    required List<Locale> locale,
    this.ecmaPolicy = defaultPolicy,
    this.locales = allLocales,
    this.localeMatcher = LocaleMatcher.lookup,
  })  : _locale = locale,
        assert(ecmaPolicy is! SometimesEcma ||
            locales.every(ecmaPolicy.ecmaLocales.contains)) {
    setFormatters(locale);
  }

  Intl.includeLocales({
    List<Locale> initialLocales = const ['en'],
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> includedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          locale: initialLocales,
          ecmaPolicy: ecmaPolicy,
          locales: includedLocales,
        );

  Intl.excludeLocales({
    List<Locale> defaultLocale = const ['en'],
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> excludedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          locale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          locales: allLocales
              .where((locale) => !excludedLocales.contains(locale))
              .toList(),
        );

  Intl({
    List<Locale> defaultLocale = const ['en'],
    EcmaPolicy ecmaPolicy = defaultPolicy,
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          locale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          locales: allLocales,
        );

  void setFormatters(List<Locale> locale) {
    numberFormat = number_format.getFormatter(
      locale,
      localeMatcher,
      ecmaPolicy,
    );
    datetimeFormat = datetime_format.getFormatter(
      locale,
      localeMatcher,
      ecmaPolicy,
    );
    listFormat = list_format.getFormatter(
      locale,
      localeMatcher,
      ecmaPolicy,
    );
    collation = collator.getFormatter(
      locale,
      localeMatcher,
      ecmaPolicy,
    );
  }

  List<Locale> _locale;

  List<Locale> get locale => _locale;

  set locale(List<Locale> value) {
    _locale = value;
    setFormatters(locale);
  }

  /// Whether to use the browser with the current settings
  bool get useEcma {
    final shouldUse = ecmaPolicy.useFor(locale);
    final canUse = true;
    return shouldUse && canUse;
  }
}

/// ICU4X will be compiled into the application, so there is no need to
/// specify any data here. Users may want to add additional data at runtime,
/// which could be supported through this API.
///
/// TODO: Wire this through to the ICU4X formatters.
final Map<String, List<Icu4xKey>> additionalICU4XData = {};

void addIcu4XData(Data data) {
  final callbackFromICUTellingMeWhatLocalesTheDataContained =
      extractKeysFromData();
  additionalICU4XData
      .addAll(callbackFromICUTellingMeWhatLocalesTheDataContained);
  throw UnimplementedError('Call to ICU4X here');
}

Map<String, List<Icu4xKey>> extractKeysFromData() {
  //TODO: Add implementation
  return {};
}
