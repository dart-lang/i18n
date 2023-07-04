// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';

/// A strategy to decide ICU4X for i18n functionality or delegate to the
/// built-in browser support. See also
/// * [AlwaysEcma] Always use the browser (default for web)
/// * [NeverEcma] Never use the browser (default for native)
/// * [SometimesEcma] Use the browser only for the specified locales, otherwise
/// use ICU4X
/// * [SometimesICU4X] Use ICU4X only for the specified locales, otherwise use
/// the browser
sealed class EcmaPolicy {
  const EcmaPolicy();

  bool useBrowser(Locale locale);
}

/// Policy to always use the browsers built-in `Intl` functionality.
final class AlwaysEcma extends EcmaPolicy {
  const AlwaysEcma();

  @override
  bool useBrowser(Locale locale) => true;
}

/// Policy to never use the browsers built-in `Intl` functionality.
final class NeverEcma extends EcmaPolicy {
  const NeverEcma();

  @override
  bool useBrowser(Locale locale) => false;
}

/// Policy to use the browsers built-in `Intl` functionality for a specified set
/// of locales.
final class SometimesEcma extends EcmaPolicy {
  final Set<String> ecmaLocales;

  const SometimesEcma(this.ecmaLocales);

  @override
  bool useBrowser(Locale locale) => ecmaLocales.contains(locale);
}

/// Policy to use ICU4X functionality for a specified set of locales.
final class SometimesICU4X extends EcmaPolicy {
  final Set<String> icuLocales;

  const SometimesICU4X(this.icuLocales);

  @override
  bool useBrowser(Locale locale) => !icuLocales.contains(locale);
}
