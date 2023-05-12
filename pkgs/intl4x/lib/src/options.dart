// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Used to find the best match between a user's desired locales and an
/// application's supported locales.
///
/// When receiving a list of locales for which there is no perfect match in the
/// list of supported locales, it is probably not the best solution to return
/// null or an empty string.
/// Instead, the application "falls back" until it finds a matching language tag
/// associated with a suitable piece of content to insert. The exact fallback
/// algorithm is determined by this enum.
enum LocaleMatcher {
  /// See the algorithm in
  /// https://datatracker.ietf.org/doc/html/rfc4647#section-3.4.
  lookup,

  /// A matcher lets the runtime provide a locale that's at least, but possibly
  /// more, suited for the request than the result of the [lookup] algorithm.
  bestfit('best fit');

  final String? _jsName;

  String? get jsName => _jsName ?? name;

  const LocaleMatcher([this._jsName]);
}
