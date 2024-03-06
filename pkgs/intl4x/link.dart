import 'dart:io';

Future<void> main(List<String> args) async {
  final symbols = <String>[];
  if (Platform.isLinux) {
    final linkerScript = File('symbols.lds');
    await linkerScript.create();
    final contents = '''
{
  global:
    ${symbols.join(';\n    ')}
  local:
    *;
};
''';
    linkerScript.writeAsStringSync(contents);
    await Process.run('ld', [
      '-fPIC',
      '-shared',
      ...symbols.map((symbol) => ['-u', symbol]).expand((e) => e),
      '--version-script=symbols.lds',
      '--gc-sections',
      '--strip-debug',
      ...['-o', 'out.so'],
      'target/release/libicu_capi.a'
    ]);
  }
}
