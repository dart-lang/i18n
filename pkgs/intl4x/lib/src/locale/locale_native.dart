// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../bindings/lib.g.dart' as icu;
import 'locale.dart';

/// This file should be replaced by references to ICU4X when ready.

class IcuLocale extends Locale {
  final icu.Locale locale;

  IcuLocale(this.locale)
      : super(
          language: locale.language,
          region: locale.region,
          script: locale.script,
        );
}

Locale parseLocaleWithSeparatorPlaceholder(String s,
        [String separator = '-']) =>
    IcuLocale(icu.Locale.fromString(s));

//TODO: Switch to ICU4X!
Locale parseLocale(String s, [String separator = '-']) {
  if (s.contains('_')) {
    return parseLocaleWithSeparatorPlaceholder(s, '_');
  } else {
    return parseLocaleWithSeparatorPlaceholder(s);
  }
}

String toLanguageTagImpl(Locale l, [String separator = '-']) {
  final subtags = <String>[
    if (l.calendar != null) ...['ca', l.calendar!.jsName],
    if (l.caseFirst != null) l.caseFirst!.jsName,
    if (l.collation != null) l.collation!,
    if (l.hourCycle != null) ...['hc', l.hourCycle!.name],
    if (l.numberingSystem != null) l.numberingSystem!,
    if (l.numeric != null) l.numeric!.toString(),
  ];
  return <String>[
    l.language,
    if (l.script != null) l.script!,
    if (l.region != null) l.region!,
    if (subtags.isNotEmpty) 'u',
    ...subtags,
  ].join(separator);
}

Locale minimizeImpl(Locale l) => throw UnimplementedError();
Locale maximizeImpl(Locale l) => throw UnimplementedError();
