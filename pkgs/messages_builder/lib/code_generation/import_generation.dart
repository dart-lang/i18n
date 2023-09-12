import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';
import 'generation.dart';

class ImportGeneration extends Generation<Directive> {
  final GenerationOptions options;
  final Map<String, String> resourceToHash;

  ImportGeneration(this.options, this.resourceToHash);

  @override
  List<Directive> generate() {
    final serializationImports = switch (options.deserialization) {
      DeserializationType.web => [
          Directive.import('package:messages/messages_json.dart')
        ],
    };
    return serializationImports;
  }
}
