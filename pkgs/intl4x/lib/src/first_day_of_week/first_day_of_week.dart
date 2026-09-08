// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_native.dart'
    if (dart.library.js_interop) '../ecma/ecma_web.dart';
import '../locale/locale.dart';
import '../options.dart';
import 'first_day_of_week_stub.dart'
    if (dart.library.js_interop) 'first_day_of_week_ecma.dart';
import 'first_day_of_week_stub_4x.dart'
    if (dart.library.ffi) 'first_day_of_week_4x.dart';

Weekday getFirstDayOfWeek(Locale locale) =>
    useBrowser ? getFirstDayOfWeekECMA(locale) : getFirstDayOfWeek4X(locale);
