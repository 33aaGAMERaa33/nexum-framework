import 'package:nexum_framework/exceptions/packet_serialization_exception.dart';
import '../foundation/channel/friendly_buffer.dart';
import '../foundation/channel/packet.dart';
import '../foundation/channel/packet_serializer.dart';
import '../storages/packet_serializer_registry.dart';

class PacketSerializerService {
  static PacketSerializerService get instance => _instance;
  static const PacketSerializerService _instance = PacketSerializerService._();

  const PacketSerializerService._();

  FriendlyBuffer serializePacket<T extends Packet>(T packet) {
    final PacketSerializer<Packet> ? packetSerializer = PacketSerializerRegistry.instance.get(packet.runtimeType);

    if(packetSerializer == null) throw PacketSerializationException("O pacote ${packet.runtimeType} não tem um serializador");

    final FriendlyBuffer friendlyBuffer = FriendlyBuffer();

    friendlyBuffer.writeString(packetSerializer.identifier);
    friendlyBuffer.writeString(packet.uuid!);

    packetSerializer.serialize(packet, friendlyBuffer);

    return friendlyBuffer;
  }
}