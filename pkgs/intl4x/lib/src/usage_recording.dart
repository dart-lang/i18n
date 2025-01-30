// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

@RecordUse()
class RecordSymbol extends RecordUse {
  final String symbol;

  const RecordSymbol(@mustBeConst this.symbol);
}
