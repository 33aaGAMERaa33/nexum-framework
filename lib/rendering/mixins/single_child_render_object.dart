import 'dart:math';

import 'package:nexum_framework/foundation/events/input_events.dart';

import '../../foundation/events/event.dart';
import '../object.dart';

mixin SingleChildRenderObject on RenderObject {
  RenderObject ? child;

  @override
  void update() {
    super.update();
    child?.markNeedsPaint();
    child?.markNeedsLayout();
  }

  @override
  void propagateEvent<T extends Event>(T event) {
    if(child == null) return;
    if(event is! PointerEvent) {
      child!.propagateEvent(event);
      return;
    }


    if(child!.hitTest(event.position)) {
      child!.propagateEvent(event);
    }
  }

  @override
  void adoptChild(RenderObject child) {
    super.adoptChild(child);
    this.child = child;
  }

  @override
  void dropChild(RenderObject child) {
    super.dropChild(child);
    this.child = null;
  }
}