import 'dart:collection';

import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_deserializer.dart';

class PacketDeserializerRegistry {
  final HashMap<String, PacketDeserializer> _deserializers = HashMap();

  static PacketDeserializerRegistry get instance => _instance;
  static final PacketDeserializerRegistry _instance = PacketDeserializerRegistry._();

  PacketDeserializerRegistry._();

  void register<T extends Packet>(PacketDeserializer<T> packetDeserializer) {
    _deserializers[packetDeserializer.identifier] = packetDeserializer;
  }

  PacketDeserializer ? get(String identifier) {
    return _deserializers[identifier];
  }
}