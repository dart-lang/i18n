// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/memory_file_system.dart';
import 'package:collection/collection.dart';
import 'package:messages_analyzer_plugin/src/fixes/extract_to_arb_fix.dart';
import 'package:messages_analyzer_plugin/src/rules/literal_string_outside_l10n.dart';
import 'package:messages_analyzer_plugin/src/utilities/json_manipulator.dart';
import 'package:test/test.dart';

void main() {
  group('LiteralStringOutsideL10nRule.shouldLintNode', () {
    test('excludes print statements', () {
      final code = '''
void main() {
  print('Hello world');
}
''';
      final nodes = _findStringNodes(code);
      expect(nodes, isNotEmpty);
      for (final node in nodes) {
        expect(LiteralStringOutsideL10nRule.shouldLintNode(node), isFalse);
      }
    });

    test('excludes direct variable declarations and assignments', () {
      final code = '''
void main() {
  final key = 'hello';
  var x = 'world';
  x = 'assigned';
}
''';
      final nodes = _findStringNodes(code);
      expect(nodes.length, 3);
      for (final node in nodes) {
        expect(LiteralStringOutsideL10nRule.shouldLintNode(node), isFalse);
      }
    });

    test('excludes annotations, asserts, and exceptions', () {
      final code = '''
@Deprecated('old code')
void main() {
  assert(true, 'assert message');
  throw Exception('exception message');
}
''';
      final nodes = _findStringNodes(code);
      expect(nodes.length, 3);
      for (final node in nodes) {
        expect(LiteralStringOutsideL10nRule.shouldLintNode(node), isFalse);
      }
    });

    test('lints hardcoded UI string literals', () {
      final code = '''
void build() {
  Text('Hello world');
}
''';
      final nodes = _findStringNodes(code);
      expect(nodes, hasLength(1));
      expect(LiteralStringOutsideL10nRule.shouldLintNode(nodes.first), isTrue);
    });

    test('lints hardcoded string interpolation', () {
      final code = '''
void build(String name) {
  Text('Hello \$name');
}
''';
      final nodes = _findStringNodes(code);
      expect(nodes, hasLength(1));
      expect(LiteralStringOutsideL10nRule.shouldLintNode(nodes.first), isTrue);
    });
  });

  group('ExtractToArbFix helper functions', () {
    test('parseStringLiteral converts interpolation to ARB format', () {
      final code = '''
void build(String name, String appName) {
  Text('Hello \$name, welcome to \$appName!');
}
''';
      final nodes = _findStringNodes(code);
      final parsed = ExtractToArbFix.parseStringLiteral(nodes.first);
      expect(parsed, isNotNull);
      expect(parsed!.arbText, 'Hello {name}, welcome to {appName}!');
      expect(parsed.placeholders, {'name': 'name', 'appName': 'appName'});
    });

    test('generateUniqueKey generates camelCase key from text', () {
      final provider = MemoryResourceProvider();
      final arbFile = provider.getFile('/assets/l10n/en.arb');

      final key1 = ExtractToArbFix.generateUniqueKey(arbFile, 'Hello world');
      expect(key1, 'helloWorld');

      final key2 = ExtractToArbFix.generateUniqueKey(
        arbFile,
        'Hello {name}, welcome to {appName}!',
      );
      expect(key2, 'helloNameWelcomeToAppName');
    });

    test('generateUniqueKey handles collisions by appending suffix', () {
      final provider = MemoryResourceProvider();
      final arbFile = provider.getFile('/assets/l10n/en.arb');
      arbFile.writeAsStringSync('{"helloWorld": "Hello world"}');

      final key = ExtractToArbFix.generateUniqueKey(arbFile, 'Hello world');
      expect(key, 'helloWorld2');
    });

    test('buildDartReplacement generates method calls', () {
      expect(
        ExtractToArbFix.buildDartReplacement('helloWorld', <String, String>{}),
        'messages.helloWorld()',
      );
      expect(
        ExtractToArbFix.buildDartReplacement(
          'helloName',
          {'name': 'userName'},
        ),
        'messages.helloName(name: userName)',
      );
    });

    test('buildArbEntries generates clean ARB data map', () {
      final simpleEntries = ExtractToArbFix.buildArbEntries(
        'helloWorld',
        'Hello world',
        <String, String>{},
        includeLocale: true,
      );
      expect(simpleEntries, {
        '@@locale': 'en',
        'helloWorld': 'Hello world',
      });

      final paramEntries = ExtractToArbFix.buildArbEntries(
        'helloName',
        'Hello {name}',
        {'name': 'userName'},
      );
      expect(paramEntries, {
        'helloName': 'Hello {name}',
        '@helloName': {
          'placeholders': {
            'name': {'type': 'string'},
          },
        },
      });
    });

    test('ARB file discovery sorts files and identifies default template', () {
      final provider = MemoryResourceProvider();
      provider.getFile('/assets/l10n/en.arb').writeAsStringSync('{}');
      provider.getFile('/assets/l10n/es.arb').writeAsStringSync('{}');
      provider.getFile('/assets/l10n/fr.arb').writeAsStringSync('{}');

      final folder = provider.getFolder('/assets/l10n');
      final files = folder
          .getChildren()
          .whereType<File>()
          .where((f) => f.path.endsWith('.arb'))
          .sorted((a, b) => a.shortName.compareTo(b.shortName))
          .toList();

      expect(files.length, 3);
      expect(files[0].shortName, 'en.arb');
      expect(files[1].shortName, 'es.arb');
      expect(files[2].shortName, 'fr.arb');
    });
  });

  group('JsonManipulator', () {
    test('detects 2 and 4 space indentation', () {
      const twoSpaces = '{\n  "@@locale": "en"\n}\n';
      expect(JsonManipulator.detectIndent(twoSpaces), '  ');

      const fourSpaces = '{\n    "@@locale": "en"\n}\n';
      expect(JsonManipulator.detectIndent(fourSpaces), '    ');
    });

    test('createInsertion formats complete JSON file for empty text', () {
      final insertion = JsonManipulator.createInsertion('', {
        '@@locale': 'en',
        'helloWorld': 'Hello world',
      }, defaultIndent: '    ');
      expect(insertion, isNotNull);
      expect(insertion!.offset, 0);
      expect(insertion.text, contains('{\n    "@@locale": "en",'));
      expect(insertion.text, contains('    "helloWorld": "Hello world"\n}'));
    });

    test(
      'createInsertion inserts before closing brace with correct indent',
      () {
      const existing = '{\n  "@@locale": "en"\n}\n';
      final insertion = JsonManipulator.createInsertion(existing, {
        'helloWorld': 'Hello world',
      });
      expect(insertion, isNotNull);
      expect(insertion!.text, ',\n  "helloWorld": "Hello world"\n');
    });

    test('createInsertion works with 4-space indent and placeholders', () {
      const existing = '{\n    "@@locale": "en"\n}\n';
      final insertion = JsonManipulator.createInsertion(existing, {
        'helloName': 'Hello {name}',
        '@helloName': {
          'placeholders': {
            'name': {'type': 'string'},
          },
        },
      });
      expect(insertion, isNotNull);
      expect(insertion!.text, contains(',\n    "helloName": "Hello {name}",'));
      expect(insertion.text, contains('    "@helloName": {'));
      expect(insertion.text, contains('        "placeholders": {'));
    });
  });
}

List<Expression> _findStringNodes(String code) {
  final result = parseString(content: code, throwIfDiagnostics: false);
  final finder = _StringFinder();
  result.unit.accept(finder);
  return finder.nodes;
}

class _StringFinder extends RecursiveAstVisitor<void> {
  final List<Expression> nodes = [];

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    nodes.add(node);
    super.visitSimpleStringLiteral(node);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    nodes.add(node);
    super.visitStringInterpolation(node);
  }
}
