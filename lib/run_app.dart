import 'dart:async';

import 'package:nexum_framework/widgets/framework.dart';

import 'foundation/channel/channel.dart';
import 'foundation/channel/heart_beat_monitor.dart';
import 'foundation/channel/packet_manager.dart';
import 'foundation/channel/packets/sync.dart';
import 'foundation/helpers/logger.dart';
import 'nexum.dart';

bool _alreadyRun = false;

void runApp(Widget widget) async {
  if(_alreadyRun) throw "Já está em execução";
  _alreadyRun = true;

  runZoned(() async {
    final packetManager = PacketManager.initialize();

    final Channel channel = Channel.initialize(packetManager: packetManager);

    channel.start();
    HeartbeatMonitor.start();

    final SyncDataPacket response = await packetManager.sendPacketAndWaitResponse(RequestDataSyncPacket());

    final Nexum nexum = Nexum.initialize(
      release: response.release,
      fpsLimit: response.fpsLimit,
      screenSize: response.screenSize,
    );

    nexum.start(widget);
  }, zoneSpecification: ZoneSpecification(
    print: (_, _, _, line) {
      Logger.log("Print", line);
    },
  ));
}
