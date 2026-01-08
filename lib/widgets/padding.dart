import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';

import '../painting/edge_insets.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_padding.dart';
import 'framework.dart';

class Padding extends SingleChildRenderObjectWidget {
  final EdgeInsets edgeInsets;

  const Padding({
    required this.edgeInsets,
    required super.child,
  });

  @override
  RenderObject createRenderObject() => RenderPadding(edgeInsets);

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderPadding) throw IncorrectRenderObjectUpdate(renderObject, RenderPadding);

    renderObject.edgeInsets = edgeInsets;
    renderObject.update();
  }
}