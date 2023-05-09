// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'locale.dart';

/// In js, locales are not written using an underscore but using a dash.
List<String> localeToJs(List<Locale> locale) =>
    locale.map((e) => e.replaceAll('_', '-')).toList();
