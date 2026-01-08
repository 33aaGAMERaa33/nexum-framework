import 'dart:async';
import 'dart:collection';

import 'package:nexum_framework/foundation/channel/packet.dart';
import 'package:nexum_framework/foundation/channel/serializers/foundation.dart';
import 'package:nexum_framework/foundation/channel/serializers/metrics.dart';
import 'package:nexum_framework/foundation/channel/serializers/sync.dart';
import 'package:nexum_framework/foundation/channel/serializers/test_packet_serializer.dart';

import '../../exceptions/packet_handle_exception.dart';
import '../../services/packet_deserializer_service.dart';
import '../../services/packet_handler_service.dart';
import '../../services/packet_serializer_service.dart';
import '../../storages/helper_deserializer_registry.dart';
import '../../storages/helper_serializer_registry.dart';
import '../../storages/packet_deserializer_registry.dart';
import '../../storages/packet_handler_registry.dart';
import '../../storages/packet_serializer_registry.dart';
import '../helpers/logger.dart';
import 'channel.dart';
import 'deserializers/foundation.dart';
import 'deserializers/geometry.dart';
import 'deserializers/metrics.dart';
import 'deserializers/sync.dart';
import 'deserializers/test_object_deserializer.dart';
import 'deserializers/test_packet_deserializer.dart';
import 'friendly_buffer.dart';
import 'handlers/foundation.dart';
import 'handlers/test_packet_handler.dart';
import 'serializers/geometry.dart';
import 'serializers/rendering.dart';
import 'serializers/test_object_serializer.dart';
import 'serializers/ui.dart';

class PacketManager {
  static PacketManager ? _instance;
  static PacketManager get instance => _instance!;
  static bool get initialized => _instance != null;

  final HashMap<Type, List<_WaitingPacket>> _waitingsPacket = HashMap();
  final HashMap<String, _WaitingPacket> _waitingResponseHandlers = HashMap();

  PacketManager._() {
    HelperSerialzerRegistry.instance.register(TestObjectSerializer());

    HelperSerialzerRegistry.instance.register(ColorSerializer());
    HelperSerialzerRegistry.instance.register(FontSerializer());

    HelperSerialzerRegistry.instance.register(SizeSerializer());
    HelperSerialzerRegistry.instance.register(OffsetSerializer());

    HelperSerialzerRegistry.instance.register(RenderInstructionSerializer());
    HelperSerialzerRegistry.instance.register(RenderContextSerializer());
    HelperSerialzerRegistry.instance.register(SetFontInstructonSerializer());
    HelperSerialzerRegistry.instance.register(DrawRectInstructionSerializer());
    HelperSerialzerRegistry.instance.register(ClipRectInstructionSerializer());
    HelperSerialzerRegistry.instance.register(SetColorInstructionSerializer());
    HelperSerialzerRegistry.instance.register(TranslateInstructionSerializer());
    HelperSerialzerRegistry.instance.register(DrawStringInstructionSerializer());
    HelperSerialzerRegistry.instance.register(SetCompositeInstructionSerializer());
    HelperSerialzerRegistry.instance.register(CreateSubContextInstructionSerializer());

    HelperDeserializerRegistry.instance.register(OffsetDeserializer());
    HelperDeserializerRegistry.instance.register(SizeDeserializer());

    HelperDeserializerRegistry.instance.register(TextMetricsDeserializer());

    HelperDeserializerRegistry.instance.register(KeyboardInputEventDeserializer());
    HelperDeserializerRegistry.instance.register(PointerMoveEventDeserializer());
    HelperDeserializerRegistry.instance.register(PointerClickEventDeserializer());
    HelperDeserializerRegistry.instance.register(PointerScrollEventDeserializer());

    HelperDeserializerRegistry.instance.register(TestObjectDeserializer());

    PacketHandlerRegistry.instance.register(TestPacketHandler());
    PacketHandlerRegistry.instance.register(EventPacketHandler());
    PacketHandlerRegistry.instance.register(HeartBeatPacketHandler());

    PacketSerializerRegistry.instance.register(TestPacketSerializer());
    PacketSerializerRegistry.instance.register(LoggerPacketSerializer());
    PacketSerializerRegistry.instance.register(HeartBeatPacketSerializer());
    PacketSerializerRegistry.instance.register(RequestTextMetricsSerializer());
    PacketSerializerRegistry.instance.register(RequestDataSyncPacketSerializer());
    PacketSerializerRegistry.instance.register(SendRenderContextPacketSerializer());

    PacketDeserializerRegistry.instance.register(EventPacketDeserializer());
    PacketDeserializerRegistry.instance.register(HeartBeatDeserializer());
    PacketDeserializerRegistry.instance.register(TestPacketDeserializer());
    PacketDeserializerRegistry.instance.register(SyncDataPacketDeserializer());
    PacketDeserializerRegistry.instance.register(SendTextMetricsPacketDeserializer());
  }

  static PacketManager initialize() => _instance = PacketManager._();

  void handleReceivedData(FriendlyBuffer friendlyBuffer) {
    try {
      final Packet packetDeserialized = PacketDeserializerService.deserializePacket(friendlyBuffer);
      final _WaitingPacket ? waitingResponse = _waitingResponseHandlers.remove(packetDeserialized.uuid!);
      final List<_WaitingPacket> ? waitingPacket = _waitingsPacket[packetDeserialized.runtimeType];

      if(waitingResponse != null) {
        waitingResponse.callback(packetDeserialized);
        return;
      }

      try {
        PacketHandlerService.handlePacket(packetDeserialized);
      }on Exception catch(e, stack) {
        if(e is PacketHandleException) {
          if(waitingPacket != null) {
            return;
          }

          _warn(e.toString());
        }else {
          _error(stack.toString());
          _error(e.toString());
        }
      }
    }catch(e, stack) {
      _error(stack.toString());
      _error(e.toString());
    }
  }

  void sendPacket<T extends Packet>(T packet) {
    packet.uuid ??= Packet.uuidFactory.v4();

    final Channel channel = Channel.instance;
    final FriendlyBuffer packetSerialized = PacketSerializerService.instance.serializePacket(packet);

    channel.send(packetSerialized.toBytes());
  }

  void sendResponsePacket<T extends Packet, R extends Packet>({
    required T requestPacket,
    required R responsePacket
  }) {
    if(requestPacket.uuid == null) {
      _warn("Não é possivel enviar um pacote de resposta para o pacote $T pois o UUID não foi encontrado");
      return;
    }else if(responsePacket.uuid != null) {
      _warn("Não é possivel enviar o pacote de resposta pois ele já possui UUID");
      return;
    }

    responsePacket.uuid = requestPacket.uuid!;
    sendPacket(responsePacket);
  }

  Future<T?> waitPacket<T extends Packet>([Duration timeout = const Duration(milliseconds: 1000)]) {
    bool waiting = true;
    final completer = Completer<T?>();
    final List<_WaitingPacket> waitingPacket = _waitingsPacket[T] ?? [];

    Future.delayed(timeout, () {
      if(!waiting) return;
      waiting = false;
      completer.complete(null);
    });

    waitingPacket.add(_WaitingPacket(DateTime.now().millisecondsSinceEpoch, (packet) {
      if(!waiting) return;
      waiting = false;
      completer.complete(packet);
    }));

    _waitingsPacket[T] = waitingPacket;
    return completer.future;
  }

  Future<R> sendPacketAndWaitResponse<T extends Packet, R extends Packet>(T packet) {
    final Completer<R> completer = Completer();

    sendPacketAndWaitResponseWithFunction(
      packet: packet, onResponse: completer.complete,
    );

    return completer.future;
  }

  void sendPacketAndWaitResponseWithFunction<T extends Packet, R extends Packet>({
    required T packet,
    required Function(R) onResponse
  }) {
    sendPacket<T>(packet);
    _waitingResponseHandlers[packet.uuid!] = _WaitingPacket(DateTime.now().millisecondsSinceEpoch, onResponse);
  }

  void _debug(String log) {
    Logger.debug("PacketManager", log);
  }

  void _warn(String log) {
    Logger.warn("PacketManager", log);
  }

  void _error(String log) {
    Logger.error("PacketManager", log);
  }
}

class _WaitingPacket {
  final Function callback;
  final int startTime; // millisecondsSinceEpoch

  _WaitingPacket(this.startTime, this.callback);
}
