// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'library_generation.dart';

class CodeGenerator {
  final GenerationOptions options;
  final String? context;
  final String locale;
  final List<MessageWithMetadata> messages;
  final Map<String, ({String id, String hasch})> localeToResourceInfo;

  CodeGenerator(
    this.options,
    MessagesWithMetadata messageListWithMetadata,
    this.localeToResourceInfo,
  )   : assert(messageListWithMetadata.locale != null),
        context = messageListWithMetadata.context,
        locale = messageListWithMetadata.locale!,
        messages = messageListWithMetadata.messages;

  Library generate() {
    return LibraryGeneration(
      options,
      context,
      locale,
      messages,
      localeToResourceInfo,
    ).generate();
  }
}
