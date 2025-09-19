// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum Calendar {
  buddhist,
  chinese,
  coptic,
  dangi,
  ethiopianAmeteAlem('ethioaa'),
  ethiopian('ethiopic'),
  gregorian('gregory'),
  hebrew,
  indian,
  islamicUmalqura('islamic-umalqura'),
  islamicTbla('islamic-tbla'),
  islamicCivil('islamic-civil'),
  islamicRgsa('islamic-rgsa'),
  iso8601,
  japanese,
  persian,
  roc;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Calendar([this._jsName]);
}

enum Style { narrow, short, long }
