// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale_4x.dart' if (dart.library.js_interop) 'locale_ecma.dart';

/// Representing a Unicode locale identifier. It is composed of the primary
/// `language` subtag for the locale, the `region` (also referred to as
/// 'country') subtag, and the script subtag.
///
/// Examples are `de-DE`, `es-419`, or `zh-Hant-TW`.
//TODO(mosum): Add RecordUse here somehow to record which locales are used.
abstract class Locale {
  /// Generate a language tag by joining the subtags with the [separator].
  String toLanguageTag([String separator = '-']);

  /// Parse a language tag by calling to web/ICU4X functionalities.
  static Locale parse(String s) => parseLocale(s);

  @override
  String toString() => toLanguageTag();
}
