
import '../rendering/object.dart';
import '../rendering/renderers/render_view.dart';
import 'framework.dart';

class View extends SingleChildRenderObjectWidget {
  View({required super.child});

  @override
  RenderObject createRenderObject() => RenderView();

  @override
  void updateRenderObject(RenderObject renderObject) {
    assert(renderObject is View);
    renderObject.update();
  }
}