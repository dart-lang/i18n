// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';
import 'package:messages_builder/code_generation/generation.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';

class ClassGeneration extends Generation<Spec> {
  final GenerationOptions options;
  final MessageListWithMetadata messageList;

  final List<Constructor> constructors;
  final List<Field> fields;
  final List<Method> methods;

  ClassGeneration(
    this.options,
    this.messageList,
    this.constructors,
    this.fields,
    this.methods,
  );

  String getClassName(String? context) => '${context ?? ''}Messages';

  @override
  List<Spec> generate() {
    var classes = <Spec>[
      Class(
        (cb) => cb
          ..name = getClassName(messageList.context)
          ..constructors.addAll(constructors)
          ..fields.addAll(fields)
          ..methods.addAll(methods),
      ),
      Class((cb) => cb
        ..name = 'StaticIconProvider'
        ..constructors.add(Constructor(
          (p0) => p0..constant = true,
        ))),
    ];
    if (options.findByIndex) {
      classes.add(Class((cb) => cb
        ..name = indicesName(messageList.context)
        ..annotations.add(Reference('staticIconProvider'))
        ..docs.add(
            '// StaticIconProvider annotation to have constant finder ignore this class')
        ..fields.addAll(List.generate(
            messageList.messages.length,
            (index) => Field(
                  (evb) => evb
                    ..name = messageList.messages[index].name!
                    ..type = Reference('int')
                    ..assignment = Code('$index')
                    ..static = true
                    ..modifier = FieldModifier.constant,
                )))));
    }
    if (options.findByEnum) {
      classes.add(Enum((cb) => cb
        ..name = enumName(messageList.context)
        ..values.addAll(List.generate(
            messageList.messages.length,
            (index) => EnumValue(
                  (evb) => evb..name = messageList.messages[index].name,
                )))));
    }
    return classes;
  }
}
