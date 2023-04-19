// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

class GenerationOptions {
  final bool messageCalls;
  final bool findById;
  final bool findByEnum;
  final bool findByIndex;
  final bool useCleaner;
  final bool isWeb;
  final bool makeAsync;
  final bool isInline;

  GenerationOptions({
    required this.isWeb,
    required this.messageCalls,
    required this.findById,
    required this.findByEnum,
    required this.findByIndex,
    required this.useCleaner,
    required this.makeAsync,
    required this.isInline,
  });

  bool get isNative => !isWeb;

  static Future<GenerationOptions> fromPubspec(BuildStep buildStep) async {
    var pubspecId = await buildStep.findAssets(Glob('pubspec.yaml')).first;
    var pubspecData = await buildStep.readAsString(pubspecId);
    var pubspec = loadYaml(pubspecData);
    var messagesOptions = pubspec['messages'];
    var generationOptions = GenerationOptions(
      isWeb: messagesOptions['useJson'] ?? false,
      messageCalls: messagesOptions['generateMethods'] ?? true,
      findById: messagesOptions['generateFindById'] ?? false,
      findByEnum: messagesOptions['generateFindByEnum'] ?? false,
      findByIndex: messagesOptions['generateFindByIndex'] ?? false,
      useCleaner: messagesOptions['useCleaner'] ?? false,
      makeAsync: messagesOptions['async'] ?? false,
      isInline: messagesOptions['inline'] ?? false,
    );
    return generationOptions;
  }
}
