// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../display_names.dart';
import '../bindings/lib.g.dart' as icu;
import '../data.dart';
import '../data_4x.dart';
import '../locale/locale.dart';
import '../locale/locale_4x.dart';
import 'display_names_impl.dart';

DisplayNamesImpl getDisplayNames4X(
  Locale locale,
  Data data,
  DisplayNamesOptions options,
) => DisplayNames4X(locale, data, options);

class DisplayNames4X extends DisplayNamesImpl {
  final icu.LocaleDisplayNamesFormatter _formatter;
  final icu.RegionDisplayNames _regionFormatter;

  DisplayNames4X(super.locale, Data data, super.options)
    : _formatter = icu.LocaleDisplayNamesFormatter(
        data.to4X(),
        locale.to4X(),
        options.to4X(),
      ),
      _regionFormatter = icu.RegionDisplayNames(data.to4X(), locale.to4X());

  @override
  String ofCalendar(Calendar calendar) {
    throw UnsupportedError('Not supported by ICU4X yet.');
  }

  @override
  String ofCurrency(String currencyCode) {
    throw UnsupportedError('Not supported by ICU4X yet.');
  }

  @override
  String ofDateTime(DateTimeField field) {
    throw UnsupportedError('Not supported by ICU4X yet.');
  }

  @override
  String ofLanguage(Locale locale) => _formatter.of(locale.to4X());

  @override
  String ofRegion(String regionCode) => _regionFormatter.of(regionCode);

  @override
  String ofScript(String scriptCode) {
    throw UnsupportedError('Not supported by ICU4X yet.');
  }
}

extension on DisplayNamesOptions {
  icu.DisplayNamesOptions to4X() {
    final icuStyle = switch (style) {
      Style.narrow => icu.DisplayNamesStyle.narrow,
      Style.short => icu.DisplayNamesStyle.short,
      Style.long => icu.DisplayNamesStyle.long,
    };

    final icuFallback = switch (fallback) {
      Fallback.code => icu.DisplayNamesFallback.code,
      Fallback.none => icu.DisplayNamesFallback.none,
    };

    final icuLanguageDisplay = switch (languageDisplay) {
      LanguageDisplay.dialect => icu.LanguageDisplay.dialect,
      LanguageDisplay.standard => icu.LanguageDisplay.standard,
    };

    return icu.DisplayNamesOptions(
      style: icuStyle,
      fallback: icuFallback,
      languageDisplay: icuLanguageDisplay,
    );
  }
}
