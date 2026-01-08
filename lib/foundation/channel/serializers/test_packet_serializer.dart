import '../../../services/helper_serializer_service.dart';
import '../friendly_buffer.dart';
import '../packet_serializer.dart';
import '../packets/test_packet.dart';

class TestPacketSerializer extends PacketSerializer<TestPacket> {
  @override
  String get identifier => "test";

  @override
  Type get packetType => TestPacket;

  @override
  void serialize(TestPacket packet, FriendlyBuffer friendlyBuffer) {
    HelperSerializerService.instance.serializeObject(packet.testObject, friendlyBuffer);
  }
}