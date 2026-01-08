import '../../../painting/geometry.dart';
import '../friendly_buffer.dart';
import '../packet_deserializer.dart';
import '../packets/sync.dart';

class SyncDataPacketDeserializer extends PacketDeserializer<SyncDataPacket> {
  @override
  String get identifier => "sync_data";

  @override
  Type get packetType => SyncDataPacket;

  @override
  SyncDataPacket deserialize(FriendlyBuffer friendlyBuffer) {
    final double width = friendlyBuffer.readInt().toDouble();
    final double height = friendlyBuffer.readInt().toDouble();
    final int fpsLimit = friendlyBuffer.readInt();
    final bool release = friendlyBuffer.readBool();

    return SyncDataPacket(
      release: release,
      fpsLimit: fpsLimit,
      screenSize: Size(width: width, height: height),
    );
  }
}

