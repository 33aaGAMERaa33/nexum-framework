import '../../../rendering/rendering.dart';
import '../packet.dart';

class SendRenderContextPacket extends Packet {
  final RenderContext renderContext;
  SendRenderContextPacket(this.renderContext);
}