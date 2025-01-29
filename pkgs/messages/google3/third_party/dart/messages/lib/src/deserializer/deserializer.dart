// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../message_format.dart';
import '../plural_selector.dart';

abstract class Deserializer<T extends MessageList> {
  T deserialize(PluralSelector selector);
}
