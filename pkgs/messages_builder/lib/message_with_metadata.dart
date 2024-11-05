// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages.dart';

class ParameterizedMessage {
  final Message message;
  final String name;
  List<Placeholder> placeholders;

  static final RegExp _dartName = RegExp(r'^[a-zA-Z][a-zA-Z_0-9]*$');
  bool get nameIsDartConform => _dartName.hasMatch(name);

  ParameterizedMessage(this.message, List<String> arguments, this.name)
      : placeholders = arguments.map(Placeholder.new).toList();
}

class MessageFile {
  final List<ParameterizedMessage> messages;
  final String? locale;
  final String? context;
  final String hash;
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

class Placeholder {
  final String name;
  final String type;

  Placeholder(this.name, [this.type = 'String']);

  @override
  String toString() {
    return '$name: $type';
  }
}
