import '../friendly_buffer.dart';
import '../packet_serializer.dart';
import '../packets/metrics.dart';

class RequestTextMetricsSerializer extends PacketSerializer<RequestTextMetricsPacket> {
  @override
  String get identifier => "request_text_metrics";

  @override
  Type get packetType => RequestTextMetricsPacket;

  @override
  void serialize(RequestTextMetricsPacket packet, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeString(packet.value);
    friendlyBuffer.writeInt(packet.style.font.fontSize);
  }
}