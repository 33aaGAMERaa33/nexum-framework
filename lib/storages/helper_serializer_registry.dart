import 'dart:collection';

import '../foundation/channel/helper_serializer.dart';

class HelperSerialzerRegistry {
  final HashMap<Type, HelperSerializer> _serializers = HashMap();

  static HelperSerialzerRegistry get instance => _instance;
  static final HelperSerialzerRegistry _instance = HelperSerialzerRegistry._();

  HelperSerialzerRegistry._();

  void register<T>(HelperSerializer<T> helperSerializer) => _serializers[helperSerializer.objectType] = helperSerializer;
  HelperSerializer ? getSerializer(Type objectType) => _serializers[objectType];
}