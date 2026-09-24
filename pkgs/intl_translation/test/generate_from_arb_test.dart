// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  test('generate_from_arb rejects invalid locale names in ARB files', () async {
    final tempDir = await Directory.systemTemp.createTemp('arb_test');
    try {
      final dartFile = File(path.join(tempDir.path, 'main.dart'));
      await dartFile.writeAsString('void main() {}');

      final arbFile = File(path.join(tempDir.path, 'invalid.arb'));
      await arbFile.writeAsString('''{
  "@@locale": "en'\\nfinal pwn = 0xdead;\\nvar q='",
  "hello": "Hello"
}''');

      final result = await Process.run(Platform.executable, [
        path.join('bin', 'generate_from_arb.dart'),
        dartFile.path,
        arbFile.path,
      ], workingDirectory: path.join(Directory.current.path));

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('Invalid locale'));
    } finally {
      await tempDir.delete(recursive: true);
    }
  });
}
