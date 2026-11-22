// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl_translation/generate_localized.dart';
import 'package:test/test.dart';

void main() {
  test('generateMainImportFile with flutter emits dart.library.js_interop', () {
    final generated = MessageGeneration().generateMainImportFile(flutter: true);

    expect(
      generated,
      contains(
        "export 'messages_flutter.dart'\n"
        "  if (dart.library.js_interop) 'messages_all_locales.dart'\n"
        '  show initializeMessages;',
      ),
    );
    expect(generated, isNot(contains('dart.library.js)')));
  });

  test('generateMainImportFile without flutter exports all locales', () {
    final generated = MessageGeneration().generateMainImportFile();

    expect(
      generated,
      contains(
        "export 'messages_all_locales.dart'\n"
        '  show initializeMessages;',
      ),
    );
    expect(generated, isNot(contains('messages_flutter.dart')));
    expect(generated, isNot(contains('dart.library.js')));
  });
}
