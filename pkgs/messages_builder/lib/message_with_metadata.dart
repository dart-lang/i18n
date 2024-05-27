// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:messages/messages.dart';

class MessageWithMetadata {
  final Message message;
  final String name;
  List<Placeholder> placeholders;

  static final RegExp _dartName = RegExp(r'^[a-zA-Z][a-zA-Z_0-9]*$');
  bool get nameIsDartConform => _dartName.hasMatch(name);

  MessageWithMetadata(this.message, List<String> arguments, this.name)
      : placeholders = arguments.map(Placeholder.new).toList();
}

class MessagesWithMetadata {
  final List<MessageWithMetadata> messages;
  final String? locale;
  final String? context;
  final String? referencePath;
  final String hash;
  final bool hasMetadata;

  MessagesWithMetadata(
    this.messages,
    this.locale,
    this.context,
    this.referencePath,
    this.hash,
    this.hasMetadata,
  );

  MessagesWithMetadata copyWith({
    List<MessageWithMetadata>? messages,
    String? locale,
    String? context,
    String? referencePath,
    String? hash,
    bool? hasMetadata,
    AssetId? assetId,
  }) {
    return MessagesWithMetadata(
      messages ?? this.messages,
      locale ?? this.locale,
      context ?? this.context,
      referencePath ?? this.referencePath,
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
