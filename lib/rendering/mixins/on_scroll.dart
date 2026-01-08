import '../../foundation/events/event.dart';
import '../../foundation/events/input_events.dart';
import '../object.dart';

mixin OnScroll on RenderObject {
  @override
  void propagateEvent<T extends Event>(T event) {
    super.propagateEvent(event);

    if(event is PointerScrollEvent && hitTest(event.position)) {
      onScroll(event.scrollModifier, event.scrollAmount);
    }
  }

  void onScroll(int scrollModifier, int scrollAmount);
}