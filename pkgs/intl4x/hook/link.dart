// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:code_assets/code_assets.dart' show LinkInputCodeAssets;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:hooks/hooks.dart' show LinkInput, link;
import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/src/hook_helpers/shared.dart' show assetId, package;
import 'package:logging/logging.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:record_use/record_use.dart' as record_use;

const recordSymbolId = record_use.Identifier(
  importUri: 'package:intl4x/src/bindings/lib.g.dart',
  name: '_DiplomatFfiUse',
);

const timeFormatId = record_use.Identifier(
  importUri: 'package:intl4x/src/datetime_format/datetime_format.dart',
  name: 'DatetimeFormatExt|time',
);

const ymdFormatId = record_use.Identifier(
  importUri: 'package:intl4x/src/datetime_format/datetime_format.dart',
  name: 'DatetimeFormatExt|ymd',
);

/// Run the linker to turn a static into a treeshaken dynamic library.
Future<void> main(List<String> args) async {
  await link(args, (input, output) async {
    print('Start linking');
    final staticLib = input.assets.code.firstWhereOrNull(
      (asset) => asset.id == 'package:$package/$assetId',
    );
    if (staticLib == null) {
      // No static lib built, so assume a dynamic one was already bundled.
      return;
    }

    output.addDependency(staticLib.file!);

    final usages = input.usages;

    final timeZonesTimeFormat = _usedTimeZonesTimeFormat(usages);
    final timeZonesDateFormat = _usedTimeZonesDateFormat(usages);

    final usedSymbols = usages
        ?.constantsOf(recordSymbolId)
        .map((instance) => instance['symbol'] as String)
        .whereNot(
          (symbol) =>
              _isUnusedSymbol(
                symbol,
                'icu4x_ZonedTimeFormatter_create_',
                timeZonesTimeFormat,
              ) ||
              _isUnusedSymbol(
                symbol,
                'icu4x_ZonedDateFormatter_create_',
                timeZonesDateFormat,
              ),
        );

    print('''
### Using symbols:
${usedSymbols?.join('\n')}
### End using symbols
''');

    await CLinker.library(
      name: input.packageName,
      assetName: assetId,
      sources: [staticLib.file!.path],
      linkerOptions: LinkerOptions.treeshake(symbols: usedSymbols),
    ).run(
      input: input,
      output: output,
      logger:
          Logger('')
            ..level = Level.ALL
            ..onRecord.listen((record) => print(record.message)),
    );
  });
}

bool _isUnusedSymbol(String symbol, String prefix, Set<String>? usedSymbols) =>
    symbol.startsWith(prefix) && !(usedSymbols?.contains(symbol) ?? true);

Set<String>? _usedTimeZonesTimeFormat(record_use.RecordedUsages? usages) =>
    usages
        ?.constArgumentsFor(
          timeFormatId,
          'String time(DateTime datetime, {TimeZone timeZone})',
        )
        .map(
          (argument) =>
              ((argument.named['timeZone'] as Map)['type'] as Map)['index']
                  as int,
        )
        .map((index) => TimeZoneType.values[index])
        .map(
          (timeZoneType) => switch (timeZoneType) {
            TimeZoneType.long =>
              'icu4x_ZonedTimeFormatter_create_specific_long_mv1',
            TimeZoneType.short =>
              'icu4x_ZonedTimeFormatter_create_specific_short_mv1',
            TimeZoneType.shortOffset =>
              'icu4x_ZonedTimeFormatter_create_localized_offset_short_mv1',
            TimeZoneType.longOffset =>
              'icu4x_ZonedTimeFormatter_create_localized_offset_long_mv1',
            TimeZoneType.shortGeneric =>
              'icu4x_ZonedTimeFormatter_create_generic_short_mv1',
            TimeZoneType.longGeneric =>
              'icu4x_ZonedTimeFormatter_create_generic_long_mv1',
          },
        )
        .toSet();

Set<String>? _usedTimeZonesDateFormat(record_use.RecordedUsages? usages) =>
    usages
        ?.constArgumentsFor(
          ymdFormatId,
          'String ymd(DateTime datetime, {TimeZone timeZone})',
        )
        .map(
          (argument) =>
              ((argument.named['timeZone'] as Map)['type'] as Map)['index']
                  as int,
        )
        .map((index) => TimeZoneType.values[index])
        .map(
          (timeZoneType) => switch (timeZoneType) {
            TimeZoneType.long =>
              'icu4x_ZonedDateFormatter_create_specific_long_mv1',
            TimeZoneType.short =>
              'icu4x_ZonedDateFormatter_create_specific_short_mv1',
            TimeZoneType.shortOffset =>
              'icu4x_ZonedDateFormatter_create_localized_offset_short_mv1',
            TimeZoneType.longOffset =>
              'icu4x_ZonedDateFormatter_create_localized_offset_long_mv1',
            TimeZoneType.shortGeneric =>
              'icu4x_ZonedDateFormatter_create_generic_short_mv1',
            TimeZoneType.longGeneric =>
              'icu4x_ZonedDateFormatter_create_generic_long_mv1',
          },
        )
        .toSet();

extension on LinkInput {
  record_use.RecordedUsages? get usages {
    if (recordedUsagesFile == null) {
      return null;
    }
    final usagesContent = File.fromUri(recordedUsagesFile!).readAsStringSync();
    final usagesJson = jsonDecode(usagesContent) as Map<String, dynamic>;
    return record_use.RecordedUsages.fromJson(usagesJson);
  }
}
