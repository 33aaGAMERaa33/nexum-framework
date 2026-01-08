import 'package:nexum_framework/exceptions/packet_deserialization_exception.dart';

import '../foundation/channel/friendly_buffer.dart';
import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_deserializer.dart';
import '../storages/packet_deserializer_registry.dart';

class PacketDeserializerService {
  static PacketDeserializerService get instance => _instance;
  static const PacketDeserializerService _instance = PacketDeserializerService._();

  const PacketDeserializerService._();

  static Packet deserializePacket(FriendlyBuffer friendlyBuffer) {
    final String identifier = friendlyBuffer.readString();
    final String uuid = friendlyBuffer.readString();

    final PacketDeserializer ? packetDeserializer = PacketDeserializerRegistry.instance.get(identifier);

    if(packetDeserializer == null) {
      throw PacketDeserializationException(
        "Não foi possivel encontrar o deserializador para o pacote: $identifier"
      );
    }


    final Packet packet = packetDeserializer.deserialize(friendlyBuffer);
    packet.uuid = uuid;

    return packet;
  }
}