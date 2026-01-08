
import '../../foundation/events/event.dart';
import '../../foundation/events/input_events.dart';
import '../object.dart';

mixin OnPointerTap on RenderObject {
  @override
  void propagateEvent<T extends Event>(T event) {
    super.propagateEvent(event);

    if(event is InputEvent) {
      onInput(event);
    }
  }

  void onInput(InputEvent event);
}