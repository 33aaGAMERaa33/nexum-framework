import '../../../nexum.dart';
import '../packet_handler.dart';
import '../packets/foundation.dart';

class EventPacketHandler extends PacketHandler<EventPacket> {
  @override
  void handle(EventPacket packet) {
    if(!Nexum.initialized) return;
    Nexum.instance.propagateEvent(packet.event);
  }

  @override
  Type get packetType => EventPacket;
}