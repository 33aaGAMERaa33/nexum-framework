import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';

import '../rendering/object.dart';
import '../rendering/renderers/render_constrained_box.dart';
import 'framework.dart';

class SizedBox extends SingleChildRenderObjectWidget {
  final double ? width;
  final double ? height;

  const SizedBox({
    super.child,
    this.width,
    this.height,
  });

  @override
  RenderObject createRenderObject() => RenderConstrainedBox(width: width, height: height);

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderConstrainedBox) throw IncorrectRenderObjectUpdate(renderObject, RenderConstrainedBox);

    renderObject.width = width;
    renderObject.height = height;
    renderObject.update();
  }
}