import 'dart:convert';
import 'dart:io';

import 'package:asset_bundle/asset_bundle.dart';
import 'package:messages/build_files.dart';
import 'package:messages/resources_asset.dart';
import 'package:messages_shrinker/messages_shrinker.dart';

/// Takes the resources.json as input, and outputs the MessagesResourcesAssets
/// to be bundled in the assets.
void main(List<String> args) {
  final input = args.first;

  final resources = Resources.fromString(input);
  final ourIdentifiers = resources.identifiers
      .where((identifier) => identifier.name == 'generate');
  final entries = ourIdentifiers
      .expand((identifier) => identifier.files)
      .expand((file) => file.references.map((reference) {
            final assetNumber = int.parse(reference.arguments['5'].toString());
            return MapEntry(assetNumber, file.part);
          }));
  final assetToPart = Map.fromEntries(entries);

  final partToAssets = <int, Iterable<int>>{};
  for (final entry in assetToPart.entries) {
    partToAssets.update(
      entry.value,
      (value) => [...value, entry.key],
      ifAbsent: () => [entry.key],
    );
  }

  final buildOutput = BuildOutput.fromJson(args[1]);

  for (final assetFile in buildOutput.filesPerPackage['messages']!) {
    final file = File(assetFile.output).readAsStringSync();
    final messagesToKeep = ourIdentifiers
        .where((element) => element.uri == assetFile.input)
        .expand((identifier) => identifier.files)
        .expand((file) => file.references.map((reference) {
              final assetNumber =
                  int.parse(reference.arguments['5'].toString());
              return assetNumber;
            }))
        .toList();
    for (final entry in partToAssets.entries) {
      final messagesInPart =
          entry.value.where(messagesToKeep.contains).toList();
      if (messagesInPart.isNotEmpty) {
        final shrinkJson = MessageShrinker().shrinkJson(file, messagesInPart);
        final key = MessagesAssetBundle.generateKey(
          'name',
          entry.key,
          'en',
        );
        File('assets/$key').writeAsStringSync(shrinkJson);
      }
    }
  }

  print(jsonEncode({
    'resources_messages:': MessagesResourcesAssets(assetToPart).serialize(),
  }));
}
