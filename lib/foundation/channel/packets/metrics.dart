import '../../../painting/text_style.dart';
import '../../metrics/text_metrics.dart';
import '../packet.dart';

class RequestTextMetricsPacket extends Packet {
  final String value;
  final TextStyle style;

  RequestTextMetricsPacket({
    required this.value,
    required this.style,
  });
}

class SendTextMetricsPacket extends Packet {
  final TextMetrics textMetrics;
  SendTextMetricsPacket(this.textMetrics);
}