import '../../foundation/events/event.dart';
import '../../foundation/events/input_events.dart';
import '../object.dart';

mixin MultiChildRenderObject on RenderObject {
  final List<RenderObject> childrens = [];

  @override
  void adoptChild(RenderObject child) {
    super.adoptChild(child);
    if(childrens.contains(child)) return;
    childrens.add(child);
  }

  @override
  void dropChild(RenderObject child) {
    childrens.remove(child);
    super.dropChild(child);
  }

  @override
  void updateChild(RenderObject oldChild, RenderObject newChild) {
    super.updateChild(oldChild, newChild);

    if(!childrens.contains(oldChild)) {
      childrens.add(newChild);
      return;
    }

    final int index = childrens.indexOf(oldChild);

    childrens.removeAt(index);
    childrens.insert(index, newChild);
  }

  @override
  void propagateEvent<T extends Event>(T event) {
    if(event is! PointerEvent) {
      for(final RenderObject child in childrens) {
        child.propagateEvent(event);
      }

      return;
    }


    for(final RenderObject child in childrens) {
      if(child.hitTest(event.position)) {
        child.propagateEvent(event);
      }
    }
  }
}