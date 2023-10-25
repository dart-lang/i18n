// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'library_generation.dart';

class CodeGenerator {
  final GenerationOptions options;
  final String? context;
  final String locale;
  final Map<String, String> localeCarbPaths;
  final List<MessageWithMetadata> messages;
  final Map<String, String> resourceToHash;

  CodeGenerator(
    this.options,
    MessagesWithMetadata messageListWithMetadata,
    this.localeCarbPaths,
    this.resourceToHash,
  )   : context = messageListWithMetadata.context,
        locale = messageListWithMetadata.locale,
        messages = messageListWithMetadata.messages;

  String generate() {
    final libs = LibraryGeneration(
      options,
      context,
      locale,
      messages,
      localeCarbPaths,
      resourceToHash,
    ).generate();

    assert(libs.isNotEmpty);

    final emitter = DartEmitter(orderDirectives: true);
    final source = '${libs.first.accept(emitter)}';
    return DartFormatter().format(source);
  }
}
