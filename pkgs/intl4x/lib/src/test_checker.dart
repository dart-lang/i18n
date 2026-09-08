// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

/// Whether real i18n formatting is enabled in tests via a compile-time define.
///
/// Opting into real i18n formatting in tests makes test assertions brittle to:
/// 1. Biannual Unicode CLDR data updates (e.g. changing spacing or separators).
/// 2. Differences across browser / OS versions and engine implementations.
///
/// Only use this for golden or snapshot tests where exact output is required.
const bool allowBrittleI18nTesting = bool.fromEnvironment(
  'intl4x.brittle_i18n_testing',
  defaultValue: false,
);

/// Check if we are in a test environment, by checking for the `#test.declarer`
/// symbol defined in the zone in which a Dart test runs. The
/// `#test.allowFormatting` symbol or `-Dintl4x.brittle_i18n_testing=true`
/// can be used to override this.
bool get isInTest =>
    !allowBrittleI18nTesting &&
    Zone.current[#test.declarer] != null &&
    !(Zone.current[#test.allowFormatting] as bool? ?? false);
