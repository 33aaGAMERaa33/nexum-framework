import '../friendly_buffer.dart';
import '../packet_serializer.dart';
import '../packets/sync.dart';

class RequestDataSyncPacketSerializer extends PacketSerializer<RequestDataSyncPacket> {
  @override
  String get identifier => "request_data_sync";

  @override
  Type get packetType => RequestDataSyncPacket;

  @override
  void serialize(RequestDataSyncPacket packet, FriendlyBuffer friendlyBuffer) {

  }
}