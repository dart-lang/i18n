// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'message.dart';

abstract class IntlObject {
  const IntlObject();

  Message gender(
    Gender gender,
    Message? female,
    Message? male,
    Message other,
  );

  Message plural(
    num howMany, {
    Message? zero,
    Message? one,
    Message? two,
    Message? few,
    Message? many,
    required Message other,
    String? locale,
  });

  Message select(Object arg, Map<Object, Message> cases);
}
