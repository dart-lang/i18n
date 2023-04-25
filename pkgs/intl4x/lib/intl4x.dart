// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'src/collator/collator_choice.dart';
import 'src/datetime_format/datetime_format.dart';
import 'src/ecma_policy.dart';
import 'src/list_format/list_format.dart';
import 'src/number_format/number_format.dart';

export 'src/ecma_policy.dart';
// export 'src/number_format/number_format_options.dart'
//     show
//         CompactNotation,
//         CurrencyStyle,
//         DecimalStyle,
//         EngineeringNotation,
//         FractionDigits,
//         Notation,
//         NumberFormatOptions,
//         PercentStyle,
//         ScientificNotation,
//         SignificantDigits,
//         StandardNotation,
//         Style,
//         UnitStyle,
//         CompactDisplay,
//         CurrencyDisplay,
//         CurrencySign,
//         Grouping,
//         RoundingMode,
//         RoundingPriority,
//         SignDisplay,
//         TrailingZeroDisplay,
//         Unit,
//         UnitDisplay;

class Intl {
  final EcmaPolicy ecmaPolicy;

  String dyliblocation = 'path.dll'; //What about path.wasm? How to load this?
  String datalocation = 'data.blob'; //What about additional data?

  late final NumberFormat _numberFormat;
  late final DatetimeFormat _datetimeFormat;
  late final ListFormat _listFormat;
  late final CollatorChoice _collator;

  Intl({
    this.ecmaPolicy = const AlwaysEcma(),
    this.locale = 'en',
    this.availableLocales = const {},
    this.availableData = const {},
  }) {
    _numberFormat = NumberFormat(this);
    _datetimeFormat = DatetimeFormat(this);
    _listFormat = ListFormat(this);
    _collator = CollatorChoice(this);
  }

  String locale;

  final Set<String> availableLocales;
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
  CollatorChoice get collator => _collator;
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
