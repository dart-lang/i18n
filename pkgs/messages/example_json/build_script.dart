import 'dart:io';

import 'package:messages/build_files.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> args) async {
  // Process.runSync('dart', ['compile', 'exe', 'bin/example.dart']);
  final files = await Directory('lib').list().toList();

  final filesPerPackage = {
    'messages': files
        .whereType<File>()
        .map((e) => e.path)
        .where((file) => path.extension(file) == '.json')
        .map((event) =>
            (input: path.setExtension(event, '.g.dart'), output: event))
        .toList(),
  };

  print(BuildOutput(filesPerPackage: filesPerPackage).toJson());
}
