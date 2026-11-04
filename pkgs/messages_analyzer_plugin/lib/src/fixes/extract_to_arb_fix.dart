// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../utilities/json_manipulator.dart';

class ExtractToArbFix extends ResolvedCorrectionProducer {
  static const _fixKind = FixKind(
    'extract_to_arb',
    50,
    "Extract string to '{0}'",
  );

  ExtractToArbFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _fixKind;

  @override
  List<String>? get fixArguments {
    final targetFile = _findTargetArbFile();
    return [path.basename(targetFile.path)];
  }

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final stringNode = _findStringLiteralNode();
    if (stringNode == null) return;

    final parsed = parseStringLiteral(stringNode);
    if (parsed == null || parsed.arbText.trim().isEmpty) return;

    final targetArbFile = _findTargetArbFile();

    final key = generateUniqueKey(targetArbFile, parsed.arbText);

    // 1. Compute Dart file edit (replace with messages.<key>(...)).
    final dartReplacement = buildDartReplacement(key, parsed.placeholders);
    await builder.addDartFileEdit(unitResult.file.path, (dartBuilder) {
      dartBuilder.addSimpleReplacement(stringNode.sourceRange, dartReplacement);
    });

    // 2. Compute ARB file edit (insert new key and placeholder metadata).
    final includeLocale = !targetArbFile.exists;
    final arbEntries = buildArbEntries(
      key,
      parsed.arbText,
      parsed.placeholders,
      includeLocale: includeLocale,
    );
    final existingContent = targetArbFile.exists
        ? targetArbFile.readAsStringSync()
        : '';
    final insertion = JsonManipulator.createInsertion(
      existingContent,
      arbEntries,
    );
    if (insertion != null) {
      await builder.addGenericFileEdit(targetArbFile.path, (genericBuilder) {
        genericBuilder.addSimpleInsertion(insertion.offset, insertion.text);
      });
    }
  }

  Expression? _findStringLiteralNode() {
    AstNode? candidate = node;
    while (candidate != null) {
      if (candidate is SimpleStringLiteral ||
          candidate is StringInterpolation) {
        return candidate as Expression;
      }
      candidate = candidate.parent;
    }
    return null;
  }

  @visibleForTesting
  static ParsedString? parseStringLiteral(Expression node) {
    if (node is SimpleStringLiteral) {
      return ParsedString(arbText: node.value, placeholders: {});
    } else if (node is StringInterpolation) {
      final buffer = StringBuffer();
      final placeholders = <String, String>{};
      var paramIndex = 1;

      for (final element in node.elements) {
        if (element is InterpolationString) {
          buffer.write(element.value);
        } else if (element is InterpolationExpression) {
          var name = _deriveParameterName(element.expression);
          if (name == null || name.isEmpty) {
            name = 'param$paramIndex';
          }
          var candidateName = name;
          var count = 2;
          while (placeholders.containsKey(candidateName)) {
            candidateName = '$name$count';
            count++;
          }
          placeholders[candidateName] = element.expression.toSource();
          buffer.write('{$candidateName}');
          paramIndex++;
        }
      }
      return ParsedString(
        arbText: buffer.toString(),
        placeholders: placeholders,
      );
    }
    return null;
  }

  static String? _deriveParameterName(Expression expr) => switch (expr) {
    SimpleIdentifier() => expr.name,
    PropertyAccess() => expr.propertyName.name,
    PrefixedIdentifier() => expr.identifier.name,
    MethodInvocation() => expr.methodName.name,
    _ => null,
  };

  @visibleForTesting
  static String generateUniqueKey(File arbFile, String arbText) {
    final words = arbText
        .split(RegExp(r'[^a-zA-Z0-9]+'))
        .where((w) => w.isNotEmpty)
        .toList();

    String baseKey;
    if (words.isNotEmpty) {
      final count = 5;
      baseKey = _camelCase(words, count);
    } else {
      baseKey = 'message';
    }

    final existingKeys = <String>{};
    if (arbFile.exists) {
      try {
        final content = arbFile.readAsStringSync();
        final decoded = jsonDecode(content) as Map<String, dynamic>;
        existingKeys.addAll(decoded.keys.whereType<String>());
      } catch (_) {
        // Ignore JSON parse errors in fallback.
      }
    }

    var key = baseKey;
    var count = 2;
    while (existingKeys.contains(key) || existingKeys.contains('@$key')) {
      key = '$baseKey$count';
      count++;
    }
    return key;
  }

  static String _camelCase(List<String> words, int count) {
    final selected = words.take(count).toList();
    final first = selected.first.toLowerCase();
    final rest = selected
        .skip(1)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join('');
    return '$first$rest';
  }

  @visibleForTesting
  static String buildDartReplacement(
    String key,
    Map<String, String> placeholders,
  ) {
    if (placeholders.isEmpty) {
      return 'messages.$key()';
    }
    final args = placeholders.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    return 'messages.$key($args)';
  }

  @visibleForTesting
  static Map<String, Object?> buildArbEntries(
    String key,
    String arbText,
    Map<String, String> placeholders, {
    bool includeLocale = false,
  }) {
    return {
      if (includeLocale) '@@locale': 'en',
      key: arbText,
      if (placeholders.isNotEmpty)
        '@$key': {
          'placeholders': {
            for (final p in placeholders.keys) p: {'type': 'string'},
          },
        },
    };
  }

  File _findTargetArbFile() {
    final arbDir = _findArbFolderRelativePath();
    if (arbDir.exists) {
      final arbFiles = arbDir
          .getChildren()
          .whereType<File>()
          .where((f) => f.path.endsWith('.arb'))
          .sorted((a, b) => a.shortName.compareTo(b.shortName))
          .toList();
      if (arbFiles.isNotEmpty) {
        final enFile = arbFiles.firstWhereOrNull(
          (f) => f.shortName == 'en.arb' || f.shortName.endsWith('_en.arb'),
        );
        return enFile ?? arbFiles.first;
      }
    }
    return arbDir.getFile('en.arb');
  }

  Folder _findArbFolderRelativePath() {
    var arbFolderRel = 'assets/l10n/';
    final provider = unitResult.session.resourceProvider;
    var dir = provider.getFolder(path.dirname(unitResult.file.path));
    while (true) {
      final pubspecFile = dir.getFile('pubspec.yaml');
      if (pubspecFile.exists) {
        try {
          final yaml = loadYaml(pubspecFile.readAsStringSync());
          if (yaml is Map) {
            final packageOptions = yaml['package_options'];
            if (packageOptions is Map) {
              final builderOptions = packageOptions['messages_builder'];
              if (builderOptions is Map) {
                final arbInputFolder = builderOptions['arb_input_folder'];
                if (arbInputFolder is String && arbInputFolder.isNotEmpty) {
                  arbFolderRel = arbInputFolder;
                }
              }
            }
          }
        } catch (_) {
          // Fallback to default assets/l10n/
        }
        break;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }

    final arbDir = provider.getFolder(
      path.normalize(path.join(dir.path, arbFolderRel)),
    );
    return arbDir;
  }
}

class ParsedString {
  final String arbText;
  final Map<String, String> placeholders;

  ParsedString({required this.arbText, required this.placeholders});
}
