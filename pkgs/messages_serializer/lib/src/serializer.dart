import 'package:messages/message_format.dart';

class Serialization<T> {
  final T data;

  Serialization(this.data);
}

abstract class Deserializer<T extends MessageList> {
  T deserialize();
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
