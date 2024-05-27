// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages/messages_build.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) {
  build(args, (config, output) async {
    final builder = MessageBuilder(
      arbFiles: ['lib/testarb.arb', 'lib/testarbctx2.arb'],
      locales: ['en', 'de', 'fr'],
    );

    await builder.run(config: config, output: output, logger: null);
  });
}
