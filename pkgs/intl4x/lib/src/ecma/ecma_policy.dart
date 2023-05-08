// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../locale.dart';

/// The policy on whether to use the browsers built-in `Intl` functionality, or
/// rather use ICU4X,
sealed class EcmaPolicy {
  const EcmaPolicy();

  bool useFor(List<Locale> locales);
}

/// Policy to always use the browsers built-in `Intl` functionality.
final class AlwaysEcma extends EcmaPolicy {
  const AlwaysEcma();

  @override
  bool useFor(List<Locale> locales) => true;
}

/// Policy to never use the browsers built-in `Intl` functionality.
final class NeverEcma extends EcmaPolicy {
  const NeverEcma();

  @override
  bool useFor(List<Locale> locales) => false;
}

/// Policy to use the browsers built-in `Intl` functionality for a specified set
/// of locales.
final class SometimesEcma extends EcmaPolicy {
  final Set<String> ecmaLocales;

  const SometimesEcma(this.ecmaLocales);

  @override
  bool useFor(List<Locale> locales) =>
      ecmaLocales.any((locale) => locales.contains(locale));
}
