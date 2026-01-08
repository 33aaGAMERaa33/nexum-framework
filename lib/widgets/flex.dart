import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';
import 'package:nexum_framework/painting/axis.dart';

import '../rendering/object.dart';
import '../rendering/renderers/render_flex.dart';
import 'framework.dart';

class Flex extends MultiChildRenderObjectWidget {
  final Axis axis;
  final int spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  const Flex({
    this.spacing = 0,
    required this.axis,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    required List<Widget> childrens,
  }) : super(childrens);

  @override
  RenderObject createRenderObject() => RenderFlex(
    spacing: spacing,
    axis: axis,
    mainAxisSize: mainAxisSize,
    mainAxisAlignment: mainAxisAlignment,
  );

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderFlex) throw IncorrectRenderObjectUpdate(renderObject, RenderFlex);

    renderObject.spacing = spacing;
    renderObject.axis = axis;
    renderObject.mainAxisSize = mainAxisSize;
    renderObject.mainAxisAlignment = mainAxisAlignment;

    renderObject.update();
  }
}

class Column extends Flex {
  const Column({
    super.spacing = 0,
    required super.childrens,
    super.mainAxisSize = MainAxisSize.max,
    super.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(axis: Axis.vertical);
}

class Row extends Flex {
  const Row({
    super.spacing = 0,
    required super.childrens,
    super.mainAxisSize = MainAxisSize.max,
    super.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(axis: Axis.horizontal);
}