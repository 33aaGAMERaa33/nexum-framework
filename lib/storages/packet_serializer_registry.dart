import 'dart:collection';

import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_serializer.dart';

class PacketSerializerRegistry {
  final HashMap<Type, PacketSerializer> _serializers = HashMap();

  static PacketSerializerRegistry get instance => _instance;
  static final PacketSerializerRegistry _instance = PacketSerializerRegistry._();

  PacketSerializerRegistry._();

  void register<T extends Packet>(PacketSerializer<T> packetSerializer) {
    _serializers[packetSerializer.packetType] = packetSerializer;
  }

  PacketSerializer ? get(Type packetType) {
    return _serializers[packetType];
  }
}