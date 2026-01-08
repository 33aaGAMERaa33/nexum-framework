import '../../../painting/geometry.dart';
import '../packet.dart';

class RequestDataSyncPacket extends Packet {

}

class SyncDataPacket extends Packet {
  final int fpsLimit;
  final bool release;
  final Size screenSize;

  SyncDataPacket({
    required this.release,
    required this.fpsLimit,
    required this.screenSize,
  });

  @override
  String toString() => "SyncDataPacket(fpsLimit: $fpsLimit, screenSize: $screenSize)";
}