// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale.dart';

/// This file should be replaced by references to ICU4X when ready.

Locale parseLocaleWithSeparatorPlaceholder(String s, [String separator = '-']) {
  final parsed = s.split(separator);
  // ignore: unused_local_variable
  final subtags = parsed.skipWhile((value) => value != 'u').toList();
  final tags = parsed.takeWhile((value) => value != 'u').toList();
  final language = tags.first;
  final String? script;
  final String? region;
  if (tags.length == 2) {
    if (tags[1].length == 2 && tags[1] == tags[1].toUpperCase()) {
      region = tags[1];
      script = null;
    } else {
      region = null;
      script = tags[1];
    }
  } else if (tags.length == 3) {
    script = tags[1];
    region = tags[2];
  } else {
    script = null;
    region = null;
  }

  return Locale(
    language: language,
    region: region,
    script: script,
  );
}

//TODO: Switch to ICU4X!
Locale parseLocale(String s, [String separator = '-']) {
  if (s.contains('_')) {
    return parseLocaleWithSeparatorPlaceholder(s, '_');
  } else {
    return parseLocaleWithSeparatorPlaceholder(s);
  }
}

String toLanguageTagImpl(Locale l, [String separator = '-']) {
  final subtags = [
    if (l.calendar != null) ...['ca', l.calendar],
    if (l.caseFirst != null) l.caseFirst,
    if (l.collation != null) l.collation,
    if (l.hourCycle != null) ...['hc', l.hourCycle],
    if (l.numberingSystem != null) l.numberingSystem,
    if (l.numeric != null) l.numeric,
  ];
  return [
    l.language,
    if (l.script != null) l.script,
    if (l.region != null) l.region,
    if (subtags.isNotEmpty) 'u',
    ...subtags,
  ].join(separator);
}

Locale minimizeImpl(Locale l) => throw UnimplementedError();
Locale maximizeImpl(Locale l) => throw UnimplementedError();
