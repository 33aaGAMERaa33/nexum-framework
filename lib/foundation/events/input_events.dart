import '../../painting/geometry.dart';
import 'event.dart';

abstract class InputEvent extends Event {

}

class KeyboardInputEvent extends InputEvent {
  final int keyCode;
  final bool released;
  KeyboardInputEvent(this.keyCode, this.released);
}

abstract class PointerEvent extends InputEvent {
  final Offset position;
  PointerEvent(this.position);
}

class PointerClickEvent extends PointerEvent {
  final bool released;
  PointerClickEvent(super.position, this.released);
}

class PointerMoveEvent extends PointerEvent {
  PointerMoveEvent(super.position);
}

class PointerScrollEvent extends PointerEvent {
  final int scrollModifier;
  final int scrollAmount;

  PointerScrollEvent({
    required this.scrollModifier,
    required this.scrollAmount,
    required Offset position,
  }) : super(position);
}