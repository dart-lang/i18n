import 'package:messages/messages.dart';

class Serialization<T> {
  final T data;

  Serialization(this.data);
}

abstract class Serializer<T> {
  final bool writeIds;

  Serializer(this.writeIds);

  Serialization<T> serialize(
    String hash,
    String locale,
    List<Message> messages,
  );
}
