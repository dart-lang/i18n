// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

enum Calendar {
  buddhist,
  traditionalChinese,
  coptic,
  traditionalKorean,
  ethiopianAmeteAlem('ethioaa'),
  ethiopian('ethiopic'),
  gregorian('gregory'),
  hebrew,
  indian,
  hijriUmalqura('islamic-umalqura'),
  hijriTbla('islamic-tbla'),
  hijriCivil('islamic-civil'),
  japanese,
  persian,
  minguo;

  String get jsName => _jsName ?? name;

  final String? _jsName;

  const Calendar([this._jsName]);
}

enum NumberingSystem {
  arab,
  arabext,
  bali,
  beng,
  deva,
  fullwide,
  gujr,
  guru,
  hanidec,
  khmr,
  knda,
  laoo,
  latn,
  limb,
  mlym,
  mong,
  mymr,
  orya,
  tamldec,
  telu,
  thai,
  tibt,
}

enum Style { narrow, short, long }
