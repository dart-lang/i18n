// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/specs/library.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;

import 'arb_parser.dart';
import 'code_generation/code.dart';
import 'code_generation/import_generation.dart';
import 'generation_options.dart';
import 'message_with_metadata.dart';

Builder messagesBuilder(BuilderOptions options) =>
    MessagesBuilder(options.config);

class MessagesBuilder implements Builder {
  final Map<String, dynamic> config;

  MessagesBuilder(this.config);

  @override
  Map<String, List<String>> get buildExtensions => {
        'l10n.messages': ['messages.g.dart'],
        // '^pubspec.yaml': [],
        // '.arb': [],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final s = await GenerationOptions.getPubspecFrom(buildStep);
    final generationOptions = await GenerationOptions.fromPubspec(s);
    await BuildStepGenerator(buildStep, generationOptions).build();
  }
}

class BuildStepGenerator {
  final BuildStep buildStep;
  final GenerationOptions options;

  BuildStepGenerator(this.buildStep, this.options);

  Future<void> build() async {
    final allMessageFiles = await getParsedMessageFiles();
    final libraries = <Library>[];
    for (final input in allMessageFiles) {
      final parentFile = getParentFile(allMessageFiles, input);
      final reducedMessageFile =
          scrub(input.$2, parentFile.$2.messages.map((e) => e.name).toList());
      if (parentFile.$1 == input.$1) {
        final library = await writeDartLibrary(
          allMessageFiles,
          reducedMessageFile,
        );
        libraries.add(library);
      }
    }
    if (libraries.isNotEmpty) {
      final imports = ImportGeneration(options).generate();

      Code pluralSelectorBody() {
        return switch (options.pluralSelector) {
          PluralSelectorType.intl => const Code('''
return Intl.pluralLogic(
    howMany,
    few: few,
    many: many,
    zero: numberCases?[0] ?? wordCases?[0],
    one: numberCases?[1] ?? wordCases?[1],
    two: numberCases?[2] ?? wordCases?[2],
    other: other,
    locale: currentLocale,
  );
  '''),
          PluralSelectorType.intl4x => const Code('''
Message getCase(int i) => numberCases?[i] ?? wordCases?[i] ?? other;
    return switch (Intl(locale: Locale.parse(locale)).plural().select(howMany)) {
      PluralCategory.zero => getCase(0),
      PluralCategory.one => getCase(1),
      PluralCategory.two => getCase(2),
      PluralCategory.few => few ?? other,
      PluralCategory.many => many ?? other,
      PluralCategory.other => other,
    };
    '''),
          PluralSelectorType.custom => throw ArgumentError(),
        };
      }

      // Message Function(num,
      //     String locale,
      //     {Message? few,
      //     String? locale,
      //     Message? many,
      //     Map<int, Message>? numberCases,
      //     required Message other,
      //     Map<int, Message>? wordCases}) intl;
      Method pluralSelector() => Method(
            (mb) => mb
              ..name = '_pluralSelector'
              ..returns = const Reference('Message')
              ..requiredParameters.addAll([
                Parameter(
                  (pb) => pb
                    ..name = 'howMany'
                    ..type = const Reference('num')
                    ..named = false,
                ),
                Parameter(
                  (pb) => pb
                    ..name = 'locale'
                    ..type = const Reference('String')
                    ..named = false,
                ),
              ])
              ..optionalParameters.addAll([
                Parameter(
                  (pb) => pb
                    ..name = 'other'
                    ..type = const Reference('Message')
                    ..required = true
                    ..named = true,
                ),
                Parameter(
                  (pb) => pb
                    ..name = 'few'
                    ..type = const Reference('Message?')
                    ..named = true,
                ),
                Parameter(
                  (pb) => pb
                    ..name = 'many'
                    ..type = const Reference('Message?')
                    ..named = true,
                ),
                Parameter(
                  (pb) => pb
                    ..name = 'numberCases'
                    ..type = const Reference('Map<int, Message>?')
                    ..named = true,
                ),
                Parameter(
                  (pb) => pb
                    ..name = 'wordCases'
                    ..type = const Reference('Map<int, Message>?')
                    ..named = true,
                ),
              ])
              ..body = pluralSelectorBody(),
          );

      final lib = libraries.reduce((value, element) => Library(
            (p0) => p0
              ..comments.add(options.header)
              ..directives.addAll(imports)
              ..body.addAll([
                ...value.body,
                ...element.body,
                if (options.pluralSelector != PluralSelectorType.custom)
                  pluralSelector(),
              ]),
          ));

      final emitter = DartEmitter(orderDirectives: true);
      final source = '${lib.accept(emitter)}';
      final code = DartFormatter().format(source);

      await buildStep.writeAsString(
        AssetId(
            buildStep.inputId.package,
            buildStep.inputId.path
                .replaceFirst('l10n.messages', 'messages.g.dart')),
        code,
      );
    }
  }

  /// Only keep the messages which are in the parent file, as only those will
  /// get a generated method to embed them in code.
  MessagesWithMetadata scrub(
    MessagesWithMetadata inputMessageFile,
    List<String> messageNames,
  ) {
    final messages = inputMessageFile.messages
        .where((message) => messageNames.contains(message.name))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return inputMessageFile.copyWith(messages: messages);
  }

  /// Generates the Dart library which extracts the messages from their file
  /// format and makes the available to the user in a way specified through the
  /// `GenerationOptions`.
  Future<Library> writeDartLibrary(
    List<(AssetId, MessagesWithMetadata)> assetList,
    MessagesWithMetadata messageList,
  ) async {
    final resourcesInContext = assetList
        .where((resource) => resource.$2.context == messageList.context);

    final localeToResourceInfo =
        Map.fromEntries(resourcesInContext.map((resource) => MapEntry(
              resource.$2.locale ?? inferLocale(resource.$1.path) ?? 'en_US',
              (
                id: 'package:${buildStep.inputId.package}/${resource.$1.changeExtension('.json').path}',
                hasch: resource.$2.hash,
              ),
            )));

    printIncludeFilesNotification(messageList.context, localeToResourceInfo);
    return CodeGenerator(
      options,
      messageList,
      localeToResourceInfo,
    ).generate();
  }

  Future<List<(AssetId, MessagesWithMetadata)>> getParsedMessageFiles() async =>
      buildStep
          .findAssets(Glob('**.arb'))
          .asyncMap((assetId) async => (
                assetId,
                await parseMessageFile(await getArbfile(assetId), options)
              ))
          .toList();

  Future<String> getArbfile(AssetId assetId) async {
    final arbFile = await buildStep.readAsString(assetId);
    return arbFile;
  }

  /// Either get the referenced parent file, or try to infer which it might be.
  static (AssetId, MessagesWithMetadata) getParentFile(
    List<(AssetId, MessagesWithMetadata)> arbResources,
    (AssetId, MessagesWithMetadata) arb,
  ) {
    /// If the reference file is explicitly named, return that.
    if (arb.$2.referencePath != null) {
      final reference = arbResources
          .where((element) => element.$1.path == arb.$2.referencePath)
          .firstOrNull;
      if (reference != null) {
        return reference;
      }
    }

    /// If the current file is a reference for others, return the current file.
    final references = arbResources
        .where((resource) => resource.$2.referencePath == arb.$1.path);
    if (references.contains(arb)) {
      return arb;
    }

    /// Try to infer by looking at which files contain metadata, which is a sign
    /// they might be the references for others in the same context.
    final contextLeads =
        arbResources.groupListsBy((resource) => resource.$2.context);
    final contextWithMetadata = contextLeads[arb.$2.context]!
        .firstWhereOrNull((element) => element.$2.hasMetadata);
    if (contextWithMetadata != null) {
      return contextWithMetadata;
    }

    return arb;
  }

  /// Display a notification to the user to include the newly generated files
  /// in their assets.
  void printIncludeFilesNotification(
    String? context,
    Map<String, ({String hasch, String id})> localeToResource,
  ) {
    var contextMessage = 'The';
    if (context != null) {
      contextMessage = 'For the messages in $context, the';
    }
    final fileList =
        localeToResource.entries.map((e) => '\t${e.value.id}').join('\n');
    print(
        '''$contextMessage following files need to be declared in your assets:\n$fileList''');
  }
}

Future<MessagesWithMetadata> parseMessageFile(
  String arbFile,
  GenerationOptions options,
) async {
  final decoded = jsonDecode(arbFile) as Map;
  final arb = Map.castFrom<dynamic, dynamic, String, dynamic>(decoded);
  return ArbParser(options.findById).parseMessageFile(arb);
}

String? inferLocale(String localPath) {
  final skip = path.basenameWithoutExtension(localPath).split('_').skip(1);
  if (skip.isEmpty) {
    return null;
  }
  return skip.join('_');
}
