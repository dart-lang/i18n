// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A class representing a placeholder in a translation message. The
///
/// For example `placeholder` in
/// ```json
/// {
///   "name": "Hello {placeholder}!",
///   "@name": {
///     "description": "Initial welcome message",
///     "placeholders": {
///       "placeholder": {
///         "type": "String"
///       },
///     }
///   },
///   ...
/// }
/// ```
/// or also in
/// ```json
/// {
///   "name": "Hello {placeholder}!",
///   ...
/// }
/// ```
class Placeholder {
  final String name;
  final String? type;
  final String? example;

  Placeholder(this.name, [this.type, this.example]);

  @override
  String toString() {
    return '$name: $type';
  }
}
