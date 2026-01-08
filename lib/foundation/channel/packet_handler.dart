import 'package:nexum_framework/foundation/channel/packet.dart';

abstract class PacketHandler<T extends Packet> {
  Type get packetType;

  void handle(T packet);
}