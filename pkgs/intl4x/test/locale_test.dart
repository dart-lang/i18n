import 'package:intl4x/intl4x.dart';
import 'package:test/test.dart';

void main() {
  test('Default locale is set', () {
    expect(Intl().locale.language, isNotEmpty);
  });
}
