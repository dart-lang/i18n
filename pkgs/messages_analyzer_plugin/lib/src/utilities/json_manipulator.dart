// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

class JsonInsertion {
  final int offset;
  final String text;

  const JsonInsertion(this.offset, this.text);
}

class JsonManipulator {
  /// Detects indentation string used in [jsonText], defaulting to
  /// [defaultIndent].
  static String detectIndent(
    String jsonText, {
    String defaultIndent = '  ',
  }) {
    final match = RegExp(r'^(\s+)"', multiLine: true).firstMatch(jsonText);
    if (match != null) {
      return match.group(1)!;
    }
    return defaultIndent;
  }

  /// Creates a [JsonInsertion] to insert [newEntries] into [existingJsonText],
  /// preserving existing indentation.
  ///
  /// If [existingJsonText] is empty or has no closing brace '}', an insertion
  /// at offset 0 representing the complete JSON file is returned.
  /// Otherwise, an insertion right before the closing brace '}' is returned.
  static JsonInsertion? createInsertion(
    String existingJsonText,
    Map<String, Object?> newEntries, {
    String defaultIndent = '  ',
  }) {
    final closeIndex = existingJsonText.lastIndexOf('}');
    if (closeIndex == -1) {
      final encoder = JsonEncoder.withIndent(defaultIndent);
      return JsonInsertion(0, '${encoder.convert(newEntries)}\n');
    }

    final indent = detectIndent(
      existingJsonText,
      defaultIndent: defaultIndent,
    );
    final encoder = JsonEncoder.withIndent(indent);
    final encoded = encoder.convert(newEntries);

    // Extract the inner lines between '{' and '}'.
    final lines = encoded.split('\n');
    if (lines.length < 2) return null;

    final innerLines = lines.sublist(1, lines.length - 1);
    final innerText = innerLines.join('\n');

    final hasExisting = _hasExistingEntries(existingJsonText);

    final buffer = StringBuffer();
    if (hasExisting) {
      buffer.writeln(',');
    } else {
      buffer.writeln();
    }
    buffer.write(innerText);
    buffer.writeln();

    return JsonInsertion(closeIndex, buffer.toString());
  }

  static bool _hasExistingEntries(String jsonText) {
    final first = jsonText.indexOf('{');
    final last = jsonText.lastIndexOf('}');
    if (first == -1 || last == -1 || first >= last) return false;

    final content = jsonText.substring(first + 1, last).trim();
    return content.isNotEmpty;
  }
}
