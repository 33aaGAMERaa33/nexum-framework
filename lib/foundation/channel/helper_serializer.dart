import 'friendly_buffer.dart';

abstract class HelperSerializer<T> {
  const HelperSerializer();
  String get identifier;
  Type get objectType;
  void serialize(T object, FriendlyBuffer friendlyBuffer);
}