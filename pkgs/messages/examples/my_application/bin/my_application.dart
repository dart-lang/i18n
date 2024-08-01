import 'package:my_application/my_application.dart';

Future<void> main(List<String> arguments) async {
  print('Currently: ${await sale()}. ${await items()}!');
}
