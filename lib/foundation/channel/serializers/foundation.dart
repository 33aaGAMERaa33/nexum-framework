import '../friendly_buffer.dart';
import '../packet_serializer.dart';
import '../packets/foundation.dart';

class HeartBeatPacketSerializer extends PacketSerializer<HeartBeatPacket> {
  @override
  void serialize(HeartBeatPacket packet, FriendlyBuffer friendlyBuffer) {
  }

  @override
  String get identifier => "heart_beat";

  @override
  Type get packetType => HeartBeatPacket;
}

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