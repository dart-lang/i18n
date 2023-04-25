// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

abstract class EcmaPolicy {
  const EcmaPolicy();

  bool useFor(String locale);
}

class AlwaysEcma extends EcmaPolicy {
  const AlwaysEcma();

  @override
  bool useFor(String locale) => true;
}

class NeverEcma extends EcmaPolicy {
  const NeverEcma();

  @override
  bool useFor(String locale) => false;
}

class SometimesEcma extends EcmaPolicy {
  final Set<String> useForLocales;

  const SometimesEcma(this.useForLocales);

  @override
  bool useFor(String locale) => useForLocales.contains(locale);
}
