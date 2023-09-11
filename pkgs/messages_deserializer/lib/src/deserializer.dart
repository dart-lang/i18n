import 'package:messages/messages.dart';

abstract class Deserializer<T extends MessageList> {
  T deserialize(IntlObject intl);
}
