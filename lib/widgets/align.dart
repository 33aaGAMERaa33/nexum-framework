import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';

import '../painting/alignament.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_align.dart';
import 'framework.dart';

class Align extends SingleChildRenderObjectWidget {
  final Alignment alignment;

  const Align({
    this.alignment = Alignment.topLeft,
    required super.child,
  });

  @override
  RenderObject createRenderObject() => RenderAlign(alignment);

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderAlign) throw IncorrectRenderObjectUpdate(renderObject, RenderAlign);

    renderObject.alignment = alignment;
    renderObject.update();
  }
}

class Center extends Align {
  const Center({required super.child}) : super(alignment: Alignment.center);
}