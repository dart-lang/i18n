import 'package:messages/varint.dart';
import 'package:test/test.dart';

void main() {
  test('int -> varint -> int', () {
    void testNum(int n) {
      expect(VarInt.fromVarint(VarInt.toVarint(n)).value, n);
    }

    testNum(5);
    testNum(50);
    testNum(2000);
    testNum(1112063);
    testNum(268435456);
  });
}
