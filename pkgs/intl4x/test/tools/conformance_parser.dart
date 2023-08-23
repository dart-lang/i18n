// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  final pathToCurrent = args.first;
  final pathToReference = args.last;
  final infos = getInfos(getJson(pathToCurrent, 'dart_web'));
  final referenceInfos = getInfos(getJson(pathToReference, 'dart_web'));

  final markdown = StringBuffer('''
| Case | Total | Passing | Failing | Error | Unsupported |
| ---- | ----- | ------- | ------- | ----- | ----------- |
''');
  for (final entry in infos.entries) {
    final referenceInfo = referenceInfos[entry.key];
    markdown.writeln(
        '| ${entry.key} ${entry.value.getRow(referenceInfo ?? Info())}');
  }
  print(markdown);

  final errorMessage = compare(infos, referenceInfos);
  if (errorMessage == null) {
    exit(0);
  } else {
    exit(1);
  }
}

String? compare(Map<String, Info> infos, Map<String, Info> referenceInfos) {
  for (final entry in infos.entries) {
    final info = entry.value;
    final referenceInfo = referenceInfos[entry.key];
    if (referenceInfo != null) {
      final failureMessage = shouldFail(info, referenceInfo);
      if (failureMessage != null) {
        return failureMessage;
      }
    }
  }
  return null;
}

String? shouldFail(Info info, Info referenceInfo) {
  final moreErrors =
      info.error > referenceInfo.error ? 'Too many new errors' : null;
  final moreFailing =
      info.failing > referenceInfo.failing ? 'Too many new failing' : null;
  final moreUnsupported = info.unsupported > referenceInfo.unsupported
      ? 'Too many new unsupported'
      : null;
  return moreErrors ?? moreFailing ?? moreUnsupported;
}

Map<String, Info> getInfos(Map<String, dynamic> current) {
  final infos = <String, Info>{};
  for (final entry in current.entries) {
    final caseName = entry.key;
    final caseInfos = entry.value as List;
    final caseInfo = caseInfos.firstOrNull as Map<String, dynamic>?;
    if (caseInfo != null) {
      infos[caseName] = Info(
        total: caseInfo['test_count'] as int,
        error: caseInfo['error_count'] as int,
        failing: caseInfo['fail_count'] as int,
        passing: caseInfo['pass_count'] as int,
        unsupported: caseInfo['unsupported_count'] as int,
      );
    }
  }
  return infos;
}

Map<String, dynamic> getJson(String pathToCurrent, String exec) {
  final file = File(pathToCurrent);
  if (!file.existsSync()) return <String, dynamic>{};
  final currentStr = file.readAsStringSync();
  final decoded = jsonDecode(currentStr) as Map<String, dynamic>;

  return decoded.map((key, value) {
    final list = (value as List)
        .where((element) => (element as Map)['exec'] == exec)
        .toList();
    return MapEntry(key, list);
  });
}

class Info {
  final int total;
  final int passing;
  final int failing;
  final int error;
  final int unsupported;

  Info({
    this.total = 0,
    this.passing = 0,
    this.failing = 0,
    this.error = 0,
    this.unsupported = 0,
  });

  String getRow(Info reference) {
    final columnItems = [
      _getString(total, reference.total),
      _getString(passing, reference.passing),
      _getString(failing, reference.failing),
      _getString(error, reference.error),
      _getString(unsupported, reference.unsupported),
    ];
    return '| ${columnItems.join(' | ')} |';
  }

  String _getString(int current, int reference) {
    final change = (reference - current) / current;
    String changeStr;
    if (!change.isNaN) {
      final changePercent = change * 100;
      final changeClamped = max(min(changePercent, 100), -100);
      String prefix;
      if (changeClamped > 0) {
        prefix = ':arrow_upper_right:';
      } else if (changeClamped < 0) {
        prefix = ':arrow_lower_right:';
      } else {
        prefix = ':arrow_right:';
      }
      changeStr = '$prefix ${changeClamped.toStringAsFixed(2)} %';
    } else {
      changeStr = '';
    }
    final s = '$current $changeStr';
    return s;
  }
}
