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
import 'src/locale.dart';
import 'src/number_format/number_format.dart';
import 'src/number_format/number_format_4x.dart';
import 'src/number_format/number_format_stub.dart'
    if (dart.library.js) 'src/number_format/number_format_ecma.dart';
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

  late NumberFormat numberFormat;
  late DatetimeFormat datetimeFormat;
  late ListFormat listFormat;
  late Collator collation;

  /// Construct an [Intl] instance providing the current [locale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    required List<Locale> locale,
    this.ecmaPolicy = defaultPolicy,
    this.locales = allLocales,
    this.localeMatcher = LocaleMatcher.lookup,
  })  : _locale = locale,
        assert(ecmaPolicy is SometimesEcma &&
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
    if (useEcma) {
      numberFormat = getNumberFormatter(locale, localeMatcher) ??
          getNumberFormatter4X(locale);
      datetimeFormat = getDatetimeFormatter(locale, localeMatcher) ??
          getDatetimeFormatter4X(locale);
      listFormat =
          getListFormatter(locale, localeMatcher) ?? getListFormatter4X(locale);
      collation = getCollator(locale, localeMatcher) ?? getCollator4X(locale);
    } else {
      numberFormat = getNumberFormatter4X(locale);
      datetimeFormat = getDatetimeFormatter4X(locale);
      listFormat = getListFormatter4X(locale);
      collation = getCollator4X(locale);
    }
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
