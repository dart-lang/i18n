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

/// Matches a valid BCP47 Unicode extension type: one or more subtags of three
/// to eight lowercase letters or digits, separated by hyphens, for example
/// `japanese` or `islamic-civil`. Values that do not match, such as the
/// `America/New_York` in `timezone=America/New_York`, are dropped.
final _unicodeExtensionType = RegExp(r'^[a-z0-9]{3,8}(?:-[a-z0-9]{3,8})*$');

/// Matches a BCP47 Unicode extension key: a letter or digit followed by a
/// letter, for example `ca` or `rg`.
final _unicodeExtensionKey = RegExp(r'^[a-z0-9][a-z]$');

/// The Unicode extension keys for ICU's legacy keyword names, as used in
/// Apple's `CFLocale` identifiers. Keywords that already use the BCP47 key,
/// such as `rg` or `fw`, need no entry.
const _legacyKeywordToKey = {
  'calendar': 'ca',
  'colalternate': 'ka',
  'colbackwards': 'kb',
  'colcasefirst': 'kf',
  'colcaselevel': 'kc',
  'collation': 'co',
  'colnormalization': 'kk',
  'colnumeric': 'kn',
  'colreorder': 'kr',
  'colstrength': 'ks',
  'currency': 'cu',
  'hours': 'hc',
  'measure': 'ms',
  'numbers': 'nu',
  'timezone': 'tz',
};

/// The Unicode extension types for ICU's legacy keyword values, per key, where
/// they differ. Boolean `yes` and `no` values are handled separately.
const _legacyTypeToType = {
  'ca': {'gregorian': 'gregory', 'ethiopic-amete-alem': 'ethioaa'},
  'co': {
    'dictionary': 'dict',
    'gb2312han': 'gb2312',
    'phonebook': 'phonebk',
    'traditional': 'trad',
  },
  'ka': {'non-ignorable': 'noignore'},
  'ks': {
    'primary': 'level1',
    'secondary': 'level2',
    'tertiary': 'level3',
    'quaternary': 'level4',
    'identical': 'identic',
  },
  'ms': {'imperial': 'uksystem'},
};

/// The collation types for the alternative sort orders that Windows appends to
/// locale names, such as the `phoneb` in `de-DE_phoneb`.
///
/// Hungarian `tchncl` and Georgian `modern` have no equivalent and are dropped.
const _windowsSortOrderToCollation = {
  'phoneb': 'phonebk',
  'pronun': 'zhuyin',
  'radstr': 'unihan',
  'stroke': 'stroke',
  'tradnl': 'trad',
};

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
///   `en_US@calendar=japanese;hours=h23`.
///
/// Preferences are kept as Unicode extensions where possible: Apple's
/// keywords (`@calendar=japanese` becomes `-u-ca-japanese`), Windows sort
/// orders (`_phoneb` becomes `-u-co-phonebk`), and glibc's `@euro` modifier
/// (`-u-cu-eur`). Names that already are BCP47 tags, including any extensions,
/// are returned unchanged.
///
/// Returns `und` for the `C` and `POSIX` locales and for empty names.
String platformLocaleNameToBcp47(String localeName) {
  // The pattern matches every input, see its documentation.
  final match = _posixLocalePattern.firstMatch(localeName)!;
  var base = match.group(1)!;
  final modifier = match.group(2);

  // Unicode extension keys mapped to their types, for example `ca: japanese`.
  final keywords = <String, String>{};

  // Windows appends an alternative sort order after an underscore to an
  // otherwise hyphenated tag, for example `de-DE_phoneb` or `es-ES_tradnl`.
  // This only has to be checked after removing the codeset, as codesets such
  // as `UTF-8` contain a hyphen. Only an underscore after the first hyphen
  // starts a sort order; one before it, as in `sr_Latn-RS`, is a separator.
  final hyphenIndex = base.indexOf('-');
  final underscoreIndex = base.indexOf('_');
  if (hyphenIndex != -1 && underscoreIndex > hyphenIndex) {
    final sortOrder = base.substring(underscoreIndex + 1).toLowerCase();
    base = base.substring(0, underscoreIndex);
    final collation = _windowsSortOrderToCollation[sortOrder];
    if (collation != null) {
      keywords['co'] = collation;
    }
  }

  if (base.isEmpty || base == 'C' || base == 'POSIX') {
    return 'und';
  }

  final subtags = base.split(_subtagSeparator);
  if (modifier != null && modifier.contains('=')) {
    // ICU-style keywords, as in Apple's `en_US@calendar=japanese;hours=h23`.
    _addLegacyKeywords(modifier, keywords);
  } else {
    // glibc modifiers. `@latin` and `@cyrillic` select a script, as in
    // `sr_RS@latin`, and `@euro` selects the currency. Others are dropped.
    switch (modifier) {
      case 'latin':
        subtags.insert(1, 'Latn');
      case 'cyrillic':
        subtags.insert(1, 'Cyrl');
      case 'euro':
        keywords['cu'] = 'eur';
    }
  }

  // A name that already is a BCP47 tag may have its own extensions. Those are
  // kept as they are, as a tag can only have one Unicode extension.
  final hasExtensions = subtags.any((subtag) => subtag.length == 1);
  if (keywords.isNotEmpty && !hasExtensions) {
    subtags.add('u');
    // Unicode extension keywords are sorted by key in canonical form.
    for (final key in keywords.keys.toList()..sort()) {
      subtags
        ..add(key)
        ..add(keywords[key]!);
    }
  }
  return subtags.join('-');
}

/// Adds the Unicode extension keywords for ICU-style [keywords], such as
/// `calendar=japanese;hours=h23`, to [result].
///
/// Unknown keys and values that are not valid Unicode extension types are
/// dropped.
void _addLegacyKeywords(String keywords, Map<String, String> result) {
  for (final keyword in keywords.split(';')) {
    final separatorIndex = keyword.indexOf('=');
    if (separatorIndex == -1) continue;
    final name = keyword.substring(0, separatorIndex).trim().toLowerCase();
    final value = keyword.substring(separatorIndex + 1).trim().toLowerCase();

    final key = _legacyKeywordToKey[name] ?? name;
    if (!_unicodeExtensionKey.hasMatch(key)) continue;

    final type = switch (value) {
      'yes' => 'true',
      'no' => 'false',
      _ => _legacyTypeToType[key]?[value] ?? value,
    };
    if (!_unicodeExtensionType.hasMatch(type)) continue;

    result.putIfAbsent(key, () => type);
  }
}
