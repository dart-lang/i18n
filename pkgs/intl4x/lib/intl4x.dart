// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'collation.dart';
import 'number_format.dart';
import 'src/collation/collation_impl.dart';
import 'src/data.dart';
import 'src/ecma/ecma_policy.dart';
import 'src/ecma/ecma_stub.dart' if (dart.library.js) 'src/ecma/ecma_web.dart';
import 'src/locale.dart';
import 'src/number_format/number_format.dart';
import 'src/number_format/number_format_impl.dart';
import 'src/options.dart';

typedef Icu4xKey = String;

/// The main class for all i18n calls, containing references to other
/// functions such as
/// * [NumberFormatBuilder]
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

  final List<Locale> supportedLocales;
  final LocaleMatcher localeMatcher;

  Collation collation([CollationOptions options = const CollationOptions()]) =>
      Collation(
        options,
        CollationImpl.build(currentLocale, localeMatcher, ecmaPolicy),
      );

  NumberFormat numberFormat([NumberFormatOptions? options]) => NumberFormat(
        options ?? NumberFormatOptions.custom(),
        NumberFormatImpl.build(currentLocale, localeMatcher, ecmaPolicy),
      );

  /// Construct an [Intl] instance providing the current [currentLocale] and the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions.
  Intl._({
    required this.currentLocale,
    this.ecmaPolicy = defaultPolicy,
    this.supportedLocales = allLocales,
    this.localeMatcher = LocaleMatcher.lookup,
  });

  Intl.includeLocales({
    Locale defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> includedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          currentLocale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: includedLocales,
        );

  Intl.excludeLocales({
    Locale defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
    List<Locale> excludedLocales = const [],
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          currentLocale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: allLocales
              .where((locale) => !excludedLocales.contains(locale))
              .toList(),
        );

  Intl({
    Locale defaultLocale = 'en',
    EcmaPolicy ecmaPolicy = defaultPolicy,
    LocaleMatcher localeMatcher = LocaleMatcher.lookup,
  }) : this._(
          currentLocale: defaultLocale,
          ecmaPolicy: ecmaPolicy,
          supportedLocales: allLocales,
        );

  Locale currentLocale;

  /// Whether to use the browser with the current settings
  bool get useEcma {
    final shouldUse = ecmaPolicy.useBrowser(currentLocale);
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
