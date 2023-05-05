import 'dart:typed_data';

abstract final class Data {}

final class JsonData extends Data {
  final String value;

  JsonData(this.value);
}

final class BlobData extends Data {
  final Uint8List value;

  BlobData(this.value);
}
