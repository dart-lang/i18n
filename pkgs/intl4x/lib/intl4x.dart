// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'src/collator/collation.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/ecma_policy.dart';
import 'src/list_format/list_format.dart';
import 'src/number_format/number_format.dart';

export 'src/datetime_format/datetime_format_options.dart';
export 'src/ecma_policy.dart';
export 'src/list_format/list_format_options.dart';
export 'src/number_format/number_format_options.dart';

/// The main class for all i18n calls, containing references to other
/// functions such as
/// * [NumberFormat]
/// * [DatetimeFormat]
/// * [ListFormat]
/// * [Collation].
class Intl {
  final EcmaPolicy ecmaPolicy;

  String dyliblocation = 'path.dll'; //What about path.wasm? How to load this?
  String datalocation = 'data.blob'; //What about additional data?

  late final NumberFormat _numberFormat;
  late final DatetimeFormat _datetimeFormat;
  late final ListFormat _listFormat;
  late final Collation _collator;

  /// Construct an [Intl] instance providing the current [locale], the
  /// [ecmaPolicy] defining which locales should fall back to the browser
  /// provided functions, as well as the [availableData] for each of the
  /// locales.
  Intl({
    this.locale = 'en',
    this.ecmaPolicy = const AlwaysEcma(),
    this.availableData = const {},
  }) {
    _numberFormat = NumberFormat(this);
    _datetimeFormat = DatetimeFormat(this);
    _listFormat = ListFormat(this);
    _collator = Collation(this);
  }

  String locale;

  /// The set of available locales, either through
  Set<String> get availableLocales =>
      {...ecmaPolicy.locales, ...availableData.keys};

  /// The ICU4X data for each of the locales. The exact data structure is yet
  /// to be determined.
  final Map<String, List<Icu4xKey>> availableData;

  void addSupportedLocales(Iterable<String> locales) {
    availableLocales.addAll(locales);
  }

  void addIcu4XData(Data data) {
    var callbackFromICUTellingMeWhatLocalesTheDataContained =
        <String, List<Icu4xKey>>{};
    availableData.addAll(callbackFromICUTellingMeWhatLocalesTheDataContained);
    addSupportedLocales(
        callbackFromICUTellingMeWhatLocalesTheDataContained.keys);
    throw UnimplementedError('Call to ICU4X here');
  }

  bool get useEcma =>
      ecmaPolicy is AlwaysEcma ||
      (ecmaPolicy is SometimesEcma &&
          (ecmaPolicy as SometimesEcma).useForLocales.contains(locale));

  NumberFormat get numberFormat => _numberFormat;
  DatetimeFormat get datetimeFormat => _datetimeFormat;
  ListFormat get listFormat => _listFormat;
  Collation get collator => _collator;
}

typedef Icu4xKey = String;

abstract class Data {}

class StringData {
  final String value;

  StringData(this.value);
}

class BlobData {
  final Uint8List value;

  BlobData(this.value);
}
