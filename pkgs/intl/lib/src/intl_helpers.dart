// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A library for general helper code associated with the intl library
/// rather than confined to specific parts of it.
library;

import 'global_state.dart' as global_state;

/// Type for the callback action when a message translation is not found.
typedef MessageIfAbsent = String? Function(
    String? messageText, List<Object>? args);

/// This is used as a marker for a locale data map that hasn't been initialized,
/// and will throw an exception on any usage that isn't the fallback
/// patterns/symbols provided.
class UninitializedLocaleData<F> implements MessageLookup {
  final String message;
  final F fallbackData;
  UninitializedLocaleData(this.message, this.fallbackData);

  bool _isFallback(String key) => canonicalizedLocale(key) == 'en_US';

  F operator [](String key) =>
      _isFallback(key) ? fallbackData : _throwException();

  /// If a message is looked up before any locale initialization, record it,
  /// and throw an exception with that information once the locale is
  /// initialized.
  ///
  /// Set this during development to find issues with race conditions between
  /// message caching and locale initialization. If the results of Intl.message
  /// calls aren't being cached, then this won't help.
  ///
  /// There's nothing that actually sets this, so checking this requires
  /// patching the code here.
  static final bool throwOnFallback = false;

  /// The messages that were called before the locale was initialized.
  final List<String> _badMessages = [];

  void _reportErrors() {
    if (throwOnFallback && _badMessages.isNotEmpty) {
      throw StateError(
          'The following messages were called before locale initialization:'
          ' $_uninitializedMessages');
    }
  }

  String get _uninitializedMessages =>
      (_badMessages.toSet().toList()..sort()).join('\n    ');

  @override
  String? lookupMessage(String? messageText, String? locale, String? name,
      List<Object>? args, String? meaning,
      {MessageIfAbsent? ifAbsent}) {
    if (throwOnFallback) {
      _badMessages.add((name ?? messageText)!);
    }
    return messageText;
  }

  /// Given an initial locale or null, returns the locale that will be used
  /// for messages.
  String findLocale(String? locale) =>
      locale ?? global_state.getCurrentLocale();

  List<String> get keys => _throwException() as List<String>;

  bool containsKey(String key) {
    if (!_isFallback(key)) {
      _throwException();
    }
    return true;
  }

  F _throwException() {
    throw LocaleDataException('Locale data has not been initialized'
        ', call $message.');
  }

  @override
  void addLocale(String localeName, Function findLocale) => _throwException();
}

abstract class MessageLookup {
  String? lookupMessage(String? messageText, String? locale, String? name,
      List<Object>? args, String? meaning,
      {MessageIfAbsent? ifAbsent});
  void addLocale(String localeName, Function findLocale);
}

class LocaleDataException implements Exception {
  final String message;
  LocaleDataException(this.message);
  @override
  String toString() => 'LocaleDataException: $message';
}

///  An abstract superclass for data readers to keep the type system happy.
abstract class LocaleDataReader {
  Future<String> read(String locale);
}

/// The internal mechanism for looking up messages. We expect this to be set
/// by the implementing package so that we're not dependent on its
/// implementation.
MessageLookup messageLookup =
    UninitializedLocaleData('initializeMessages(<locale>)', null);

/// Initialize the message lookup mechanism. This is for internal use only.
/// User applications should import `message_lookup_by_library.dart` and call
/// `initializeMessages`
void initializeInternalMessageLookup(Function lookupFunction) {
  if (messageLookup is UninitializedLocaleData<dynamic>) {
    // This line has to be precisely this way to work around an analyzer crash.
    (messageLookup as UninitializedLocaleData<dynamic>)._reportErrors();
    messageLookup = lookupFunction();
  }
}

/// If a message is a string literal without interpolation, compute
/// a name based on that and the meaning, if present.
// NOTE: THIS LOGIC IS DUPLICATED IN intl_translation AND THE TWO MUST MATCH.
String? computeMessageName(String? name, String? text, String? meaning) {
  if (name != null && name != '') return name;
  return meaning == null ? text : '${text}_$meaning';
}

/// Returns an index of a separator between language and other subtags.
///
/// Assumes that language length can be only 2 or 3.
int _languageSeparatorIndex(String locale) {
  if (locale.length < 3) {
    return -1;
  }
  if (locale[2] == '-' || locale[2] == '_') {
    return 2;
  }
  if (locale.length < 4) {
    return -1;
  }
  if (locale[3] == '-' || locale[3] == '_') {
    return 3;
  }
  return -1;
}

/// Returns an index of a separator between script and region.
///
/// Assumes that script contains exactly 4 characters.
int _scriptSeparatorIndex(String region) {
  if (region.length < 5) {
    return -1;
  }
  if (region[4] == '-' || region[4] == '_') {
    return 4;
  }
  return -1;
}

String canonicalizedLocale(String? aLocale) {
// Locales of length < 5 are presumably two-letter forms, or else malformed.
// We return them unmodified and if correct they will be found.
// Locales longer than 6 might be malformed, but also do occur. Do as
// little as possible to them, but make the '-' be an '_' if it's there.
// We treat C as a special case, and assume it wants en_ISO for formatting.
// TODO(alanknight): en_ISO is probably not quite right for the C/Posix
// locale for formatting. Consider adding C to the formats database.
  if (aLocale == null) return global_state.getCurrentLocale();
  if (aLocale == 'C') return 'en_ISO';
  if (aLocale.length < 5) return aLocale;

  var separatorIndex = _languageSeparatorIndex(aLocale);
  if (separatorIndex == -1) {
    return aLocale;
  }
  var language = aLocale.substring(0, separatorIndex);
  var region = aLocale.substring(separatorIndex + 1);
  // If it's longer than three it's something odd, so don't touch it.
  if (region.length <= 3) region = region.toUpperCase();
  return '${language}_$region';
}

String? verifiedLocale(String? newLocale, bool Function(String) localeExists,
    String? Function(String)? onFailure) {
// TODO(alanknight): Previously we kept a single verified locale on the Intl
// object, but with different verification for different uses, that's more
// difficult. As a result, we call this more often. Consider keeping
// verified locales for each purpose if it turns out to be a performance
// issue.
  if (newLocale == null) {
    return verifiedLocale(
        global_state.getCurrentLocale(), localeExists, onFailure);
  }
  if (localeExists(newLocale)) {
    return newLocale;
  }
  final fallbackOptions = [
    canonicalizedLocale,
    languageRegionOnlyLocale,
    languageOnlyLocale,
    deprecatedLocale,
    (locale) => deprecatedLocale(languageOnlyLocale(locale)),
    (locale) => deprecatedLocale(canonicalizedLocale(locale)),
    (_) => 'fallback'
  ];
  for (var option in fallbackOptions) {
    var localeFallback = option(newLocale);
    if (localeExists(localeFallback)) {
      return localeFallback;
    }
  }
  return (onFailure ?? _throwLocaleError)(newLocale);
}

/// The default action if a locale isn't found in verifiedLocale. Throw
/// an exception indicating the locale isn't correct.
String _throwLocaleError(String localeName) {
  throw ArgumentError('Invalid locale "$localeName"');
}

/// Return the other code for a current-deprecated locale pair. This helps in
/// situations where, for example, the user has a `he.arb` file, but gets passed
/// the `iw` locale code.
String deprecatedLocale(String aLocale) {
  switch (aLocale) {
    case 'iw':
      return 'he';
    case 'he':
      return 'iw';
    case 'fil':
      return 'tl';
    case 'tl':
      return 'fil';
    case 'id':
      return 'in';
    case 'in':
      return 'id';
    case 'no':
      return 'nb';
    case 'nb':
      return 'no';
  }
  return aLocale;
}

/// Return the short version of a locale name, e.g. 'en_US' => 'en'
String languageOnlyLocale(String aLocale) {
  // TODO(b/241094372): Remove this check.
  if (aLocale == 'invalid') {
    return 'in';
  }
  if (aLocale.length < 2) {
    return aLocale;
  }
  var separatorIndex = _languageSeparatorIndex(aLocale);
  if (separatorIndex == -1) {
    if (aLocale.length < 4) {
      // aLocale is already only a language code.
      return aLocale.toLowerCase();
    } else {
      // Something weird, returning as is.
      return aLocale;
    }
  }
  return aLocale.substring(0, separatorIndex).toLowerCase();
}

String languageRegionOnlyLocale(String aLocale) {
  if (aLocale.length < 10) return aLocale;

  var separatorIndex = _languageSeparatorIndex(aLocale);
  if (separatorIndex == -1) {
    return aLocale;
  }
  var language = aLocale.substring(0, separatorIndex);
  var subtags = aLocale.substring(separatorIndex + 1);
  separatorIndex = _scriptSeparatorIndex(subtags);
  var region = subtags.substring(separatorIndex + 1);
  // If it's longer than three it's something odd, so don't touch it.
  if (region.length <= 3) region = region.toUpperCase();
  return '${language}_$region';
}
