// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract final class EcmaPolicy {
  const EcmaPolicy();

  bool useFor(String locale);

  Set<String> get locales;
}

final class AlwaysEcma extends EcmaPolicy {
  const AlwaysEcma();

  @override
  bool useFor(String locale) => true;

  @override
  Set<String> get locales => throw UnimplementedError();
}

final class NeverEcma extends EcmaPolicy {
  const NeverEcma();

  @override
  bool useFor(String locale) => false;

  @override
  Set<String> get locales => {};
}

final class SometimesEcma extends EcmaPolicy {
  final Set<String> useForLocales;

  const SometimesEcma(this.useForLocales);

  @override
  bool useFor(String locale) => useForLocales.contains(locale);

  @override
  Set<String> get locales => useForLocales;
}
