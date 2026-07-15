// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Formatting names in different locales.
///
/// For a given [Locale], show the name of some information in that locale.
/// Provides several options as part of the [DisplayNames] constructor, such as
/// [Style], [LanguageDisplay], or [Fallback].
///
/// Languages:
/// {@example ../example/docs/display_names.dart#display_names_languages}
///
/// Regions:
/// {@example ../example/docs/display_names.dart#display_names_regions}
///
library;

// Imports for the doc comment.
import 'src/display_names/display_names.dart';
import 'src/display_names/display_names_options.dart';
import 'src/locale/locale.dart';

export 'src/display_names/display_names.dart' show DisplayNames;
export 'src/display_names/display_names_options.dart'
    show DisplayType, Fallback, LanguageDisplay, Style;
export 'src/locale/locale.dart' show Locale;
