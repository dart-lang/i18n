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

  if (compare(infos, referenceInfos)) {
    exit(0);
  } else {
    exit(1);
  }
}

bool compare(Map<String, Info> infos, Map<String, Info> referenceInfos) {
  for (final entry in infos.entries) {
    final info = entry.value;
    final referenceInfo = referenceInfos[entry.key] ?? Info();
    if (info.error > referenceInfo.error ||
        info.failing > referenceInfo.failing ||
        info.unsupported > referenceInfo.unsupported) {
      return false;
    }
  }
  return true;
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
  final currentStr = File(pathToCurrent).readAsStringSync();
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

  String _getString(int passing2, int passing3) {
    var change = (passing3 - passing2) / passing2;
    change *= 100;
    change = max(min(change, 100), -100);
    final s = '$passing2 ${change.toStringAsFixed(2)} %';
    return s;
  }
}