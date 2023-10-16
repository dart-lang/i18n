import 'package:asset_bundle/asset_bundle.dart';
import 'package:messages/resources_asset.dart';

/// Takes the resources.json as input, and outputs the MessagesResourcesAssets
/// to be bundled in the assets.
void main(List<String> args) {
  final input = args.first;

  final resources = Resources.fromString(input);
  final entries = resources.identifiers
      .where((identifier) => identifier.name == 'generate')
      .expand((identifier) => identifier.files)
      .expand((file) => file.references.map((reference) {
            final assetNumber = int.parse(reference.arguments['5'].toString());
            return MapEntry(assetNumber, file.part);
          }));
  final assetToPart = Map.fromEntries(entries);
  final output = MessagesResourcesAssets(assetToPart).serialize();

  print(output);
}
