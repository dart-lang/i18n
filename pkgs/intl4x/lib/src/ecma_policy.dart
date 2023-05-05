// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The policy on whether to use the browsers built-in `Intl` functionality, or
/// rather use ICU4X,
sealed class EcmaPolicy {
  const EcmaPolicy();

  bool useFor(String locale);

  Set<String> get locales;
}

/// Policy to always use the browsers built-in `Intl` functionality.
final class AlwaysEcma extends EcmaPolicy {
  const AlwaysEcma();

  @override
  bool useFor(String locale) => true;

  @override
  Set<String> get locales => throw UnimplementedError();
}

/// Policy to never use the browsers built-in `Intl` functionality.
final class NeverEcma extends EcmaPolicy {
  const NeverEcma();

  @override
  bool useFor(String locale) => false;

  @override
  Set<String> get locales => const {};
}

/// Policy to use the browsers built-in `Intl` functionality for a specified set
/// of locales.
final class SometimesEcma extends EcmaPolicy {
  final Set<String> useForLocales;

  const SometimesEcma(this.useForLocales);

  @override
  bool useFor(String locale) => useForLocales.contains(locale);

  @override
  Set<String> get locales => useForLocales;
}
