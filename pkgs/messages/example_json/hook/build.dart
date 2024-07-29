// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:messages_builder/hook.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) {
  build(args, (config, output) async {
    // final builder = MessagesDataBuilder.fromFiles(
    //   [
    //     'assets/l10n/testarb.arb',
    //     'assets/l10n/testarb_de.arb',
    //     'assets/l10n/testarbctx2.arb',
    //     'assets/l10n/testarbctx2_fr.arb',
    //   ],
    // );
    final builder = MessagesDataBuilder.fromFolder('assets/l10n/');

    await builder.run(config: config, output: output, logger: null);
  });
}
