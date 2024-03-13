import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  print('Regenerating bindings.');
  final intl4xDirectory = 'pkgs/intl4x/lib/src/bindings/';
  print('Deleting old bindings.');
  Directory(intl4xDirectory)
      .listSync(recursive: true)
      .forEach((element) => element.deleteSync());
  final icu4xDirectory = 'submodules/icu4x/ffi/capi/bindings/dart/';

  final directory = Directory(icu4xDirectory);
  final listSync = directory.listSync(recursive: true);
  listSync.whereType<File>().forEach((file) {
    final newPath = p.join(intl4xDirectory, p.basename(file.path));
    print('Copying $file to $newPath');
    file.copySync(newPath);
  });
  print('Done.');
}
