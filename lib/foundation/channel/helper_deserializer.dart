import 'friendly_buffer.dart';

abstract class HelperDeserializer<T> {
  String get identifier;
  Type get objectType;
  T deserialize(FriendlyBuffer friendlyBuffer);
}