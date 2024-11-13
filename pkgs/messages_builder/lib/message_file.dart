// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'parameterized_message.dart';

/// A class representing a translation message file.
///
/// It stores a list of [ParameterizedMessage]s together with some metadata such
/// as the [locale] of the messages, the [context], and the [hash] of file.
///
/// An example file might be
/// ```json
/// {
///   "@@locale": "en_US",
///   "@@context": "LoginPage",
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
class MessageFile {
  final List<ParameterizedMessage> messages;
  final String? locale;
  final String? context;
  final String hash;

  /// Whether any message in the file has metadata associated with it. This is
  /// used to determine which file is the main source of truth, and which files
  /// are translations of that main file.
  final bool hasMetadata;

  MessageFile(
    this.messages,
    this.locale,
    this.context,
    this.hash,
    this.hasMetadata,
  );

  MessageFile copyWith({
    List<ParameterizedMessage>? messages,
    String? locale,
    String? context,
    String? hash,
    bool? hasMetadata,
  }) {
    return MessageFile(
      messages ?? this.messages,
      locale ?? this.locale,
      context ?? this.context,
      hash ?? this.hash,
      hasMetadata ?? this.hasMetadata,
    );
  }
}
