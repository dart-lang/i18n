// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';
import 'placeholder.dart';

/// A wrapper class around a [Message], adding its [placeholders] and a [name].
///
/// This is the way a message is stored in the translation message ARB file,
/// for example
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
class ParameterizedMessage {
  final Message message;
  final String name;
  final List<Placeholder> placeholders;

  static final RegExp _dartName = RegExp(r'^[a-zA-Z][a-zA-Z_0-9]*$');

  ParameterizedMessage(this.message, this.name, this.placeholders);

  bool get nameIsDartConform => _dartName.hasMatch(name);
}
