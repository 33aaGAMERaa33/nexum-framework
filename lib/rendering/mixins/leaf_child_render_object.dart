import 'package:nexum_framework/rendering/object.dart';

import '../../foundation/events/event.dart';

mixin LeafChildRenderObject on RenderObject {
  @override
  void propagateEvent<T extends Event>(T event) {}
}