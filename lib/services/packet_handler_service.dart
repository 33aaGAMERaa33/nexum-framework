import 'package:nexum_framework/exceptions/packet_handle_exception.dart';
import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_handler.dart';
import '../storages/packet_handler_registry.dart';

class PacketHandlerService {
  const PacketHandlerService._();

  static void handlePacket<T extends Packet>(T packet) {
    final PacketHandler ? packetHandler = PacketHandlerRegistry.instance.get(packet.runtimeType);

    if(packetHandler == null) {
      throw PacketHandleException(
          "Handler para o pacote ${packet.runtimeType} não encontrado"
      );
    }

    packetHandler.handle(packet);
  }
}

