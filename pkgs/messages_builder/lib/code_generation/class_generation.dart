import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'generation.dart';

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
    final classes = <Spec>[
      Class(
        (cb) => cb
          ..name = getClassName(messageList.context)
          ..constructors.addAll(constructors)
          ..fields.addAll(fields)
          ..methods.addAll(methods),
      ),
    ];
    if (options.findByIndex) {
      classes.add(Class((cb) => cb
        ..name = indicesName(messageList.context)
        ..fields.addAll(List.generate(
            messageList.messages.length,
            (index) => Field(
                  (evb) => evb
                    ..name = messageList.messages[index].name!
                    ..type = const Reference('int')
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
