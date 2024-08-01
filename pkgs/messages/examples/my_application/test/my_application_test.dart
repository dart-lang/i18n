import 'package:my_application/my_application.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () async {
    await expectLater(await items(), '5 items in cart');
  });
}
