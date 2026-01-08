import '../packet_handler.dart';
import '../packets/test_packet.dart';

class TestPacketHandler extends PacketHandler<TestPacket> {
  @override
  Type get packetType => TestPacket;

  @override
  void handle(TestPacket packet) async {

  }
}