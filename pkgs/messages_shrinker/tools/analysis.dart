import 'package:messages_shrinker/const_getter.dart';

Future<void> main(List<String> args) async {
  final List<String> messageClassNames = [
    'AboutPageMessages',
    'HomePageMessages'
  ];
  final generatedFiles = {
    'AboutPageMessages':
        '/home/mosum/projects/i18n_v2/messages_shrinker/example_native/lib/testarbctx2.g.dart',
    'HomePageMessages':
        '/home/mosum/projects/i18n_v2/messages_shrinker/example_native/lib/testarb.g.dart',
  };

  final path =
      '/home/mosum/projects/i18n_v2/messages_shrinker/example_native/bin/example.dart';
  // final messages = await getMessages(path, messageClassNames);
  // print(messages);
  print(await getConst([path, ...generatedFiles.values]));
  // final messageNumbers = getMessageNumbers(
  //   messages,
  //   generatedFiles,
  // );
  // print(messageNumbers);
}
