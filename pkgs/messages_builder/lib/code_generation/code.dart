import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../generation_options.dart';
import '../message_with_metadata.dart';
import 'library_generation.dart';

class CodeGenerator {
  final GenerationOptions options;
  final String? context;
  final Map<String, String> localeCarbPaths;
  final MessageListWithMetadata messageList;
  final Map<String, String> resourceToHash;

  CodeGenerator(
    this.options,
    this.messageList,
    this.localeCarbPaths,
    this.resourceToHash,
  ) : context = messageList.context;

  String generate() {
    var libs = LibraryGeneration(
      options,
      messageList,
      localeCarbPaths,
      resourceToHash,
    ).generate();

    assert(libs.isNotEmpty);

    final emitter = DartEmitter(orderDirectives: true);
    var source = '${libs.first.accept(emitter)}';
    return DartFormatter().format(source);
  }
}
