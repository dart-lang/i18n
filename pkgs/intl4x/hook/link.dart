// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:code_assets/code_assets.dart'
    show HookConfigCodeConfig, LinkInputCodeAssets, OS;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:hooks/hooks.dart' show LinkInput, link;
import 'package:intl4x/datetime_format.dart';
import 'package:intl4x/src/hook_helpers/shared.dart' show assetId, package;
import 'package:logging/logging.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';
import 'package:record_use/record_use.dart' as record_use;

import 'identifiers.g.dart';

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

    // Collect the timezone symbols, as the API does a switch so that by
    // default, all timezone symbols would be included.
    final timeZonesTimeFormat = usages?.symbolsFor(
      timeIdentifier,
      'String time(DateTime datetime, {TimeZone timeZone})',
      'ZonedTimeFormatter',
    );
    final timeZonesDateFormat = usages?.symbolsFor(
      ymdIdentifier,
      'String ymd(DateTime datetime, {TimeZone timeZone})',
      'ZonedDateFormatter',
    );
    final timeZonesDateTimeFormat = usages?.symbolsFor(
      ymdtIdentifier,
      'String ymdt(DateTime datetime, {TimeZone timeZone})',
      'ZonedDateTimeFormatter',
    );

    final map = usages
        ?.constantsOf(diplomatFfiUseIdentifier)
        .map((instance) => instance['symbol'] as String);

    final usedSymbols = map?.whereNot(
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
          ) ||
          _isUnusedSymbol(
            symbol,
            'icu4x_ZonedDateTimeFormatter_create_',
            timeZonesDateTimeFormat,
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
      sources: [staticLib.file!.toFilePath()],
      libraries:
          // On Windows, icu4x.lib is lacking /DEFAULTLIB directives to advice
          // the linker on what libraries to link against. To make up for that,
          // the libraries used have to be provided to the linker explicitly.
          input.config.code.targetOS == OS.windows
              ? const ['MSVCRT', 'ws2_32', 'userenv', 'ntdll']
              : const [],
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

extension on record_use.RecordedUsages {
  Set<String>? symbolsFor(
    record_use.Identifier id,
    String signature,
    String formatterName,
  ) =>
      constArgumentsFor(id, signature)
          .map(
            (argument) =>
                ((argument.named['timeZone'] as Map)['type'] as Map)['index']
                    as int,
          )
          .map((index) => TimeZoneType.values[index])
          .map((timeZoneType) => timeZoneType.icuSymbol(formatterName))
          .toSet();
}

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

extension on TimeZoneType {
  String icuSymbol(String formatterName) => switch (this) {
    TimeZoneType.long => 'icu4x_${formatterName}_create_specific_long_mv1',
    TimeZoneType.short => 'icu4x_${formatterName}_create_specific_short_mv1',
    TimeZoneType.shortOffset =>
      'icu4x_${formatterName}_create_localized_offset_short_mv1',
    TimeZoneType.longOffset =>
      'icu4x_${formatterName}_create_localized_offset_long_mv1',
    TimeZoneType.shortGeneric =>
      'icu4x_${formatterName}_create_generic_short_mv1',
    TimeZoneType.longGeneric =>
      'icu4x_${formatterName}_create_generic_long_mv1',
  };
}
