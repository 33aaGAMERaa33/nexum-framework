import 'dart:collection';

import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_handler.dart';

class PacketHandlerRegistry {
  final HashMap<Type, PacketHandler> packetHandlersMap = HashMap();

  static PacketHandlerRegistry get instance => _instance;
  static final PacketHandlerRegistry _instance = PacketHandlerRegistry._();

  PacketHandlerRegistry._();

  void register<T extends Packet>(PacketHandler<T> packetHandler) => packetHandlersMap[packetHandler.packetType] = packetHandler;
  PacketHandler ? get(Type packetType) => packetHandlersMap[packetType];
}