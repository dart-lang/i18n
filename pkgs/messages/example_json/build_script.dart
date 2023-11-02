import 'dart:io';

import 'package:native_assets_cli/build_files_code.dart';
import 'package:data_assets_cli/build_files_data.dart';
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

  final buildOutput = [
    CodeBuildOutput(filesPerPackage: filesPerPackage).toJson(),
    DataBuildOutput(filesPerPackage: filesPerPackage).toJson(),
  ];
  print(buildOutput);
}
