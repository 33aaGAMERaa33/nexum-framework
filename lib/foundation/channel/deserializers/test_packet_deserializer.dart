import 'package:nexum_framework/models/test_object.dart';

import '../../../services/helper_deserializer_service.dart';
import '../friendly_buffer.dart';
import '../packet_deserializer.dart';
import '../packets/test_packet.dart';

class TestPacketDeserializer extends PacketDeserializer<TestPacket> {
  @override
  String get identifier => "test";

  @override
  Type get packetType => TestPacket;

  @override
  TestPacket deserialize(FriendlyBuffer friendlyBuffer) {
    final TestObject testObject = HelperDeserializerService.instance.deserializeObject(friendlyBuffer);
    return TestPacket(testObject);
  }
}