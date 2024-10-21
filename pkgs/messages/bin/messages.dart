import 'dart:io';

import 'package:messages_builder/message_data_builder.dart';

Future<void> main(List<String> args) async {
  await MessagesDataBuilder().run(
    inputFolder: Directory.fromUri(
        Directory.current.uri.resolve('assets/').resolve('l10n/')),
    outputFolder: Directory.fromUri(Directory.current.uri.resolve('assets/')),
    libOutput: 'lib/messages.g.dart',
  );
}
