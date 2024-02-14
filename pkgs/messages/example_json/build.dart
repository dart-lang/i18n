import 'package:messages_builder/generation_options.dart';
import 'package:messages_builder/messages_cli.dart';

Future<void> main(List<String> args) async => await buildMessages(
      args,
      'lib/',
      GenerationOptions(
        serialization: SerializationType.json,
        deserialization: DeserializationType.web,
        messageCalls: true,
        findById: true,
        indexType: IndexType.integer,
        pluralSelector: PluralSelectorType.intl4x,
      ),
    );
