import '../../../nexum.dart';
import '../heart_beat_monitor.dart';
import '../packet_handler.dart';
import '../packet_manager.dart';
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

class HeartBeatPacketHandler extends PacketHandler<HeartBeatPacket> {
  static const _pingTime = 1_000;

  @override
  void handle(HeartBeatPacket packet) {
    HeartbeatMonitor.onHeartbeat();

    Future.delayed(
      const Duration(milliseconds: _pingTime),
          () => PacketManager.instance.sendPacket(HeartBeatPacket()),
    );
  }

  @override
  Type get packetType => HeartBeatPacket;
}