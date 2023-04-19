import 'package:code_builder/code_builder.dart';

import '../generation_options.dart';

abstract class Generation<T> {
  List<T> generate();
}

String enumName(String? context) => '${context ?? ''}MessagesEnum';
String indicesName(String? context) => '${context ?? ''}MessagesIndex';

Reference getAsyncReference(String s, GenerationOptions options) =>
    Reference(options.makeAsync ? 'Future<$s>' : s);

String getDataFileName(String e) => e.split('.').first;
