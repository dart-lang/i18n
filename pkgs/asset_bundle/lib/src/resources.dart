import 'dart:convert';

class Resources {
  factory Resources.fromString(String jsonString) {
    var decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return Resources(
      identifiers: (decoded['identifiers'] as List)
          .map((e) => Identifier.fromJson(e))
          .toList(),
    );
  }

  final List<Identifier> identifiers;

  Resources({required this.identifiers});
}

class Identifier {
  final String name;
  final String id;
  final String uri;
  final bool nonConstant;
  final List<ResourceFile> files;

  Identifier({
    required this.name,
    required this.id,
    required this.uri,
    required this.nonConstant,
    required this.files,
  });

  @override
  String toString() {
    return 'Identifier(name: $name, uri: $uri, nonConstant: $nonConstant, files: $files)';
  }

  factory Identifier.fromJson(Map<String, dynamic> map) {
    return Identifier(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      uri: map['uri'] ?? '',
      nonConstant: map['nonConstant'] ?? false,
      files: List<ResourceFile>.from(
          map['files']?.map((x) => ResourceFile.fromJson(x))),
    );
  }
}

class ResourceFile {
  final int part;
  final List<ResourceReference> references;

  ResourceFile({required this.part, required this.references});

  Map<String, dynamic> toJson() {
    return {
      'part': part,
      'references': references.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() => 'ResourceFile(part: $part, references: $references)';

  factory ResourceFile.fromJson(Map<String, dynamic> map) {
    return ResourceFile(
      part: map['part']?.toInt() ?? 0,
      references: List<ResourceReference>.from(
          map['references']?.map((x) => ResourceReference.fromJson(x))),
    );
  }
}

class ResourceReference {
  final String uri;
  final int line;
  final int column;
  final Map<String, Object> arguments;

  ResourceReference({
    required this.uri,
    required this.line,
    required this.column,
    required this.arguments,
  });

  Map<String, dynamic> toJson() {
    return {
      '@': {
        'uri': uri,
        'line': line,
        'column': column,
      },
      ...arguments,
    };
  }

  @override
  String toString() {
    return 'ResourceReference(uri: $uri, line: $line, column: $column, arguments: $arguments)';
  }

  factory ResourceReference.fromJson(Map<String, dynamic> map) {
    return ResourceReference(
      uri: map['@']['uri'] ?? '',
      line: map['@']['line']?.toInt() ?? 0,
      column: map['@']['column']?.toInt() ?? 0,
      arguments: Map<String, Object>.fromEntries(map
          .map((key, value) => MapEntry(key, value as Object))
          .entries
          .skip(1)),
    );
  }
}
