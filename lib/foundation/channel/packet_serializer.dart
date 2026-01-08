import 'package:nexum_framework/foundation/channel/packet.dart';

import 'friendly_buffer.dart';

abstract class PacketSerializer<T extends Packet> {
  String get identifier;
  Type get packetType;
  void serialize(T packet, FriendlyBuffer friendlyBuffer);
}