// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'generation.dart';

class ClassGeneration {
  final GenerationOptions options;
  final List<MessageWithMetadata> messages;
  final String? context;

  final List<Constructor> constructors;
  final List<Field> fields;
  final List<Method> methods;

  ClassGeneration(
    this.options,
    this.messages,
    this.context,
    this.constructors,
    this.fields,
    this.methods,
  );

  String getClassName(String? context) => '${context ?? ''}Messages';

  List<Spec> generate() {
    final className = getClassName(context);
    final classes = <Spec>[
      Class(
        (cb) => cb
          ..name = className
          ..constructors.addAll(constructors)
          ..fields.addAll(fields)
          ..methods.addAll(methods),
      ),
    ];
    if (options.indexType == IndexType.enumerate) {
      classes.add(Enum((cb) => cb
        ..name = enumName(context)
        ..values.addAll(List.generate(
            messages.length,
            (index) => messages[index].nameIsDartConform
                ? EnumValue(
                    (evb) => evb..name = messages[index].name,
                  )
                : null).whereType<EnumValue>())));
    }
    classes.add(Extension((b) => b
      ..on = Reference(className)
      ..methods.addAll([
        if (options.findById)
          Method(
            (p0) => p0
              ..name = 'generateStringAtId'
              ..requiredParameters.addAll([
                Parameter((p0) => p0
                  ..name = 'id'
                  ..type = const Reference('String')),
                Parameter((p0) => p0
                  ..name = 'args'
                  ..type = const Reference('List'))
              ])
              ..annotations
                  .add(CodeExpression(Code("ResourceIdentifier('$className')")))
              ..lambda = true
              ..body = const Code('''
_currentMessages.generateStringAtId(id, args)
''')
              ..returns = const Reference('String'),
          ),
        //String generateStringAtIndex(int index, List args)
        if (options.messageCalls || options.indexType == IndexType.enumerate)
          Method(
            (p0) => p0
              ..name = 'generateStringAtIndex'
              ..requiredParameters.addAll([
                Parameter((p0) => p0
                  ..name = 'index'
                  ..type = const Reference('int')),
                Parameter((p0) => p0
                  ..name = 'args'
                  ..type = const Reference('List'))
              ])
              ..annotations
                  .add(CodeExpression(Code("ResourceIdentifier('$className')")))
              ..lambda = true
              ..body = const Code('''
_currentMessages.generateStringAtIndex(index, args)
''')
              ..returns = const Reference('String'),
          )
      ])));
    return classes;
  }
}
