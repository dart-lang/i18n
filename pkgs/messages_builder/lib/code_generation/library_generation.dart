// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages_builder/code_generation/class_generation.dart';
import 'package:messages_builder/code_generation/constructor_generation.dart';
import 'package:messages_builder/code_generation/field_generation.dart';
import 'package:messages_builder/code_generation/generation.dart';
import 'package:messages_builder/code_generation/import_generation.dart';
import 'package:messages_builder/code_generation/method_generation.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';

String enumName(String? context) => '${context ?? ''}MessagesEnum';
String indicesName(String? context) => '${context ?? ''}MessagesIndex';

Reference getAsyncReference(String s, GenerationOptions options) =>
    Reference(options.makeAsync ? 'Future<$s>' : s);

String getDataFileName(String e) => e.split('.').first;

class LibraryGeneration extends Generation<Library> {
  final GenerationOptions options;
  final String? context;
  final Map<String, String> localeCarbPaths;
  final MessageListWithMetadata messageList;
  final Map<String, String> resourceToHash;

  LibraryGeneration(
    this.options,
    this.messageList,
    this.localeCarbPaths,
    this.resourceToHash,
  ) : context = messageList.context;

  @override
  List<Library> generate() {
    var imports = ImportGeneration(options, resourceToHash).generate();
    var constructors = ConstructorGeneration(options).generate();

    var fields = FieldGeneration(
      options,
      localeCarbPaths,
      messageList,
      resourceToHash,
    ).generate();

    var methods = MethodGeneration(
      options,
      context,
      messageList,
      resourceToHash,
    ).generate();

    var classes = ClassGeneration(
      options,
      messageList,
      constructors,
      fields,
      methods,
    ).generate();

    return [
      Library(
        (b) => b
          ..directives.addAll(imports)
          ..body.addAll(classes)
          ..body.add(Field(
            (p0) => p0
              ..name = 'staticIconProvider'
              ..modifier = FieldModifier.constant
              ..assignment = Code('StaticIconProvider()'),
          )),
      )
    ];
  }
}
