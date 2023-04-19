import 'dart:typed_data';

class VarInt {
  final int value;
  final int length;

  VarInt._(this.value, this.length);

  static VarInt fromVarint(Uint8List n, [int start = 0]) {
    var value = 0;
    var length = 0;
    for (var i = start; i < n.length; i++) {
      var mask = (i - start) == 3 ? 255 : 127;
      var shift = (i - start) * 7;
      value += (n[i] & mask) << shift;
      if (n[i] & 128 == 0) {
        length = (i - start);
        break;
      }
    }
    return VarInt._(value, length + 1);
  }

  static Uint8List toVarint(int n) {
    var l = 1;
    if (n >= 1 << 7) l = 2;
    if (n >= 1 << 14) l = 3;
    if (n >= 1 << 21) l = 4;
    if (n > 1 << 28) {
      throw ArgumentError();
    }
    var r = Uint8List(l);
    r[0] = n & 127;
    if (l > 1) {
      r[0] += 128;
      r[1] = (n >> 7) & 127;
    }
    if (l > 2) {
      r[1] += 128;
      r[2] = (n >> 14) & 127;
    }
    if (l > 3) {
      r[2] += 128;
      r[3] = (n >> 21) & 255;
    }
    return r;
  }
}
