import '../friendly_buffer.dart';
import '../packet_serializer.dart';
import '../packets/foundation.dart';

class LoggerPacketSerializer extends PacketSerializer<LoggerPacket> {
  @override
  void serialize(LoggerPacket packet, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeString(packet.type.identifier);
    friendlyBuffer.writeString(packet.identifier);
    friendlyBuffer.writeString(packet.log);
  }

  @override
  String get identifier => "logger";

  @override
  Type get packetType => LoggerPacket;
}