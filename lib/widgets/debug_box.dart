import '../rendering/object.dart';
import '../rendering/renderers/render_debug_box.dart';
import 'framework.dart';

class DebugBox extends SingleChildRenderObjectWidget {
  DebugBox({required super.child});

  @override
  RenderObject createRenderObject() => RenderDebugBox();

  @override
  void updateRenderObject(RenderObject renderObject) {

  }
}