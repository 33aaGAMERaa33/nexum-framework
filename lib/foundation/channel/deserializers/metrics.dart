import '../../../services/helper_deserializer_service.dart';
import '../../metrics/text_metrics.dart';
import '../friendly_buffer.dart';
import '../helper_deserializer.dart';
import '../packet_deserializer.dart';
import '../packets/metrics.dart';

class TextMetricsDeserializer extends HelperDeserializer<TextMetrics> {
  @override
  String get identifier => "text_metrics";

  @override
  Type get objectType => TextMetrics;

  @override
  TextMetrics deserialize(FriendlyBuffer friendlyBuffer) {
    return TextMetrics(
      size: HelperDeserializerService.instance.deserializeObject(friendlyBuffer),
    );
  }
}

class SendTextMetricsPacketDeserializer extends PacketDeserializer<SendTextMetricsPacket> {
  @override
  String get identifier => "send_text_metrics";

  @override
  Type get packetType => SendTextMetricsPacket;

  @override
  SendTextMetricsPacket deserialize(FriendlyBuffer friendlyBuffer) {

    return SendTextMetricsPacket(
      HelperDeserializerService.instance.deserializeObject(friendlyBuffer),
    );
  }
}