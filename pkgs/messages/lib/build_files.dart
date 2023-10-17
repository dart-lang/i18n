import 'dart:convert';

class BuildOutput {
  final Map<String, Iterable<({String input, String output})>> filesPerPackage;

  BuildOutput({required this.filesPerPackage});

  Map<String, dynamic> toMap() {
    return filesPerPackage.map((key, value) =>
        MapEntry(key, value.map((e) => [e.input, e.output]).toList()));
  }

  factory BuildOutput.fromMap(Map<String, dynamic> map) {
    return BuildOutput(
      filesPerPackage: Map.from(map.map((key, value) => MapEntry(
          key,
          (value as List).map((e) =>
              (input: (e as List)[0] as String, output: e[1] as String))))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BuildOutput.fromJson(String source) =>
      BuildOutput.fromMap(json.decode(source) as Map<String, dynamic>);
}
