// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../collation.dart';

import '../locale/locale.dart';
import 'collation_impl.dart';

/// Stub for the conditional import
CollationImpl getCollator4X(Locale locale, CollationOptions options) =>
    throw UnimplementedError('Cannot use ICU4X in web environments.');
