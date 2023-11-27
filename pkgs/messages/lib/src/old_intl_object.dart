// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart' as old_intl;

import 'intl_object.dart';
import 'message.dart';

class OldIntlObject extends IntlObject {
  const OldIntlObject();
  @override
  Message gender(
    GenderEnum gender,
    Message? female,
    Message? male,
    Message other,
  ) =>
      old_intl.Intl.genderLogic<Message>(
        gender.name,
        female: female,
        male: male,
        other: other,
      );

  @override
  Message plural(
    num howMany, {
    Message? zero,
    Message? one,
    Message? two,
    Message? few,
    Message? many,
    required Message other,
    String? locale,
  }) {
    return old_intl.Intl.pluralLogic(
      howMany,
      few: few,
      many: many,
      zero: zero,
      one: one,
      two: two,
      other: other,
      locale: locale,
    );
  }

  @override
  Message select(Object arg, Map<Object, Message> cases) {
    return old_intl.Intl.selectLogic(
      arg,
      cases,
    );
  }
}
