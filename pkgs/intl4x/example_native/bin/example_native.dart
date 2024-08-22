import 'package:intl4x/intl4x.dart';

void main(List<String> arguments) {
  final intl = Intl();
  print('collation: ${intl.collation().compare('a', 'b')}!');
}
