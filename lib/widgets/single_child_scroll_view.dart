import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';
import 'package:nexum_framework/material/scroll_controller.dart';
import 'package:nexum_framework/painting/axis.dart';

import '../rendering/object.dart';
import '../rendering/renderers/render_single_child_scroll.dart';
import 'framework.dart';

class SingleChildScrollView extends SingleChildRenderObjectWidget {
  final Axis axis;
  final ScrollController controller;

  SingleChildScrollView({
    this.axis = Axis.vertical,
    ScrollController ? controller,
    required super.child,
  }) : controller = controller ?? ScrollController();

  @override
  RenderObject createRenderObject() => RenderSingleChildScrollView(
    axis: axis,
    controller: controller
  );

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderSingleChildScrollView) throw IncorrectRenderObjectUpdate(renderObject, RenderSingleChildScrollView);

    renderObject.axis = axis;
    renderObject.update();
  }
}