// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart' show LinkInput, link;
import 'package:icu4x/hook.dart' show treeshakeLibrary;
import 'package:intl4x/datetime_format.dart';
import 'package:record_use/record_use.dart' as record_use;

import 'identifiers.g.dart';

/// Run the linker to turn a static into a treeshaken dynamic library.
Future<void> main(List<String> args) async {
  await link(args, (input, output) async {
    // Collect the timezone symbols, as the API does a switch so that by
    // default, all timezone symbols would be included.

    final usages = input.usages;
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
    return treeshakeLibrary(
      input,
      output,
      symbolsToKeep: {
        'icu4x_ZonedTimeFormatter_create_': timeZonesTimeFormat,
        'icu4x_ZonedDateFormatter_create_': timeZonesDateFormat,
        'icu4x_ZonedDateTimeFormatter_create_': timeZonesDateTimeFormat,
      },
    );
  });
}

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
