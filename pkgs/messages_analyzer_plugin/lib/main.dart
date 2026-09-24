// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/fixes/extract_to_arb_fix.dart';
import 'src/rules/literal_string_outside_l10n.dart';

final plugin = MessagesAnalyzerPlugin();

class MessagesAnalyzerPlugin extends Plugin {
  @override
  String get name => 'messages_analyzer_plugin';

  @override
  void register(PluginRegistry registry) {
    registry.registerLintRule(LiteralStringOutsideL10nRule());
    registry.registerFixForRule(
      LiteralStringOutsideL10nRule.code,
      ExtractToArbFix.new,
    );
  }
}
