import '../../../painting/geometry.dart';
import '../../../services/helper_deserializer_service.dart';
import '../../events/event.dart';
import '../../events/input_events.dart';
import '../friendly_buffer.dart';
import '../helper_deserializer.dart';
import '../packet_deserializer.dart';
import '../packets/foundation.dart';

class EventPacketDeserializer extends PacketDeserializer<EventPacket> {
  @override
  EventPacket deserialize(FriendlyBuffer friendlyBuffer) {
    final Event event = HelperDeserializerService.instance.deserializeObject(friendlyBuffer);
    return EventPacket(event);
  }

  @override
  String get identifier => "event";

  @override
  Type get packetType => EventPacket;
}

class KeyboardInputEventDeserializer extends HelperDeserializer<KeyboardInputEvent> {
  @override
  KeyboardInputEvent deserialize(FriendlyBuffer friendlyBuffer) {
    final int keyCode = friendlyBuffer.readInt();
    final bool released = friendlyBuffer.readBool();

    return KeyboardInputEvent(keyCode, released);
  }

  @override
  String get identifier => "keyboard";

  @override
  Type get objectType => KeyboardInputEvent;

}

class PointerClickEventDeserializer extends HelperDeserializer<PointerClickEvent> {
  @override
  PointerClickEvent deserialize(FriendlyBuffer friendlyBuffer) {
    final Offset position = HelperDeserializerService.instance.deserializeObject(friendlyBuffer);
    final bool released = friendlyBuffer.readBool();

    return PointerClickEvent(position, released);
  }

  @override
  String get identifier => "pointer_click";

  @override
  Type get objectType => PointerClickEvent;
}

class PointerMoveEventDeserializer extends HelperDeserializer<PointerMoveEvent> {
  @override
  PointerMoveEvent deserialize(FriendlyBuffer friendlyBuffer) {
    final Offset position = HelperDeserializerService.instance.deserializeObject(friendlyBuffer);
    return PointerMoveEvent(position);
  }

  @override
  String get identifier => "pointer_move";

  @override
  Type get objectType => PointerMoveEvent;
}

class PointerScrollEventDeserializer extends HelperDeserializer<PointerScrollEvent>{
  @override
  PointerScrollEvent deserialize(FriendlyBuffer friendlyBuffer) {
    final Offset position = HelperDeserializerService.instance.deserializeObject(friendlyBuffer);
    final int scrollModifier = friendlyBuffer.readInt();
    final int scrollAmount = friendlyBuffer.readInt();

    return PointerScrollEvent(
      scrollModifier: scrollModifier,
      scrollAmount: scrollAmount,
      position: position,
    );
  }

  @override
  String get identifier => "pointer_scroll";

  @override
  Type get objectType => PointerScrollEvent;
}

class HeartBeatDeserializer extends PacketDeserializer<HeartBeatPacket> {
  @override
  HeartBeatPacket deserialize(FriendlyBuffer friendlyBuffer) {
    return HeartBeatPacket();
  }

  @override
  String get identifier => "heart_beat";

  @override
  Type get packetType => HeartBeatPacket;
}