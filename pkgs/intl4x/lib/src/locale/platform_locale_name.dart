// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Splits a POSIX locale name into its base and its modifier.
///
/// POSIX locale names have the form `language[_territory][.codeset][@modifier]`
/// (for example `sr_RS.UTF-8@latin`). Apple's `CFLocale` identifiers use the
/// same `@` syntax for keywords (for example `en_US@calendar=japanese`).
///
/// The pattern, piece by piece:
///
/// * `^([^.@]*)` - group 1, the base: everything up to the first `.` or `@`,
///   for example `sr_RS`. May be empty.
/// * `(?:\.[^@]*)?` - an optional, non-capturing codeset: a `.` followed by
///   everything up to the next `@`, for example `.UTF-8`. It is discarded.
/// * `(?:@(.*))?$` - an optional modifier: an `@` followed by the rest of the
///   string, captured as group 2, for example `latin`.
///
/// The pattern matches every input, as each part except the base is optional
/// and the base may be empty.
final _posixLocalePattern = RegExp(r'^([^.@]*)(?:\.[^@]*)?(?:@(.*))?$');

/// Matches the subtag separators found in platform locale names: `-` (BCP47,
/// Windows, Apple) and `_` (POSIX, Apple's `CFLocale` identifiers).
final _subtagSeparator = RegExp('[-_]');

/// Converts a locale name as returned by `Platform.localeName` into a BCP47
/// language tag that can be passed to `Locale.parse`.
///
/// The format of `Platform.localeName` depends on the platform:
///
/// * Linux and Android read the `LANG` environment variable, which holds a
///   POSIX locale name such as `en_US.UTF-8`, `sr_RS.UTF-8@latin`, or `C`.
/// * Windows uses `GetUserDefaultLocaleName`, which returns a BCP47-like tag,
///   optionally followed by a sort order such as `de-DE_phoneb`.
/// * macOS and iOS return the user's first preferred language, such as
///   `zh-Hans-CN`, or else a `CFLocale` identifier such as
///   `en_US@calendar=japanese`.
///
/// Returns `und` for the `C` and `POSIX` locales and for empty names.
String platformLocaleNameToBcp47(String localeName) {
  // The pattern matches every input, see its documentation.
  final match = _posixLocalePattern.firstMatch(localeName)!;
  var base = match.group(1)!;
  final modifier = match.group(2);

  // Windows appends an alternative sort order after an underscore to an
  // otherwise hyphenated tag, for example `de-DE_phoneb` or `es-ES_tradnl`.
  // This only has to be checked after removing the codeset, as codesets such
  // as `UTF-8` contain a hyphen. Only an underscore after the first hyphen
  // starts a sort order; one before it, as in `sr_Latn-RS`, is a separator.
  final hyphenIndex = base.indexOf('-');
  final underscoreIndex = base.indexOf('_');
  if (hyphenIndex != -1 && underscoreIndex > hyphenIndex) {
    base = base.substring(0, underscoreIndex);
  }

  if (base.isEmpty || base == 'C' || base == 'POSIX') {
    return 'und';
  }

  final subtags = base.split(_subtagSeparator);
  // glibc uses the `@latin` and `@cyrillic` modifiers to select a script, for
  // example `sr_RS@latin`. Other modifiers, such as `@euro` or Apple's
  // `@calendar=...` keywords, are dropped.
  final script = switch (modifier) {
    'latin' => 'Latn',
    'cyrillic' => 'Cyrl',
    _ => null,
  };
  if (script != null) {
    subtags.insert(1, script);
  }
  return subtags.join('-');
}
