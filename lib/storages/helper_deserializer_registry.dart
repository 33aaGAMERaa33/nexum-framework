import 'dart:collection';

import '../foundation/channel/helper_deserializer.dart';

class HelperDeserializerRegistry {
  final HashMap<String, HelperDeserializer> _deserializers = HashMap();

  static HelperDeserializerRegistry get instance => _instance;
  static final HelperDeserializerRegistry _instance = HelperDeserializerRegistry._();

  HelperDeserializerRegistry._();

  void register<T>(HelperDeserializer<T> helperDeserializer) {
    _deserializers[helperDeserializer.identifier] = helperDeserializer;
  }

  HelperDeserializer ? get(String identifier) {
    return _deserializers[identifier];
  }
}