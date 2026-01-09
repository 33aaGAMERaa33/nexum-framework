import 'package:nexum_framework/material/scroll_controller.dart';
import 'package:nexum_framework/painting/axis.dart';
import 'package:nexum_framework/rendering/object.dart';

import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../painting.dart';

class RenderScrollView extends RenderBox with SingleChildRenderObject {
  ScrollController scrollController;
  Axis get axis => scrollController.axis;
  Offset _scrolledOffset = Offset.zero();

  RenderScrollView({
    required this.scrollController,
  });

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    child.absoluteOffset = absoluteOffset + _scrolledOffset;
    relativeOffset = offset;

    final GetChildPaintCommand childPaintCommandGetter = GetChildPaintCommand();

    child.paint(childPaintCommandGetter, _scrolledOffset);

    final PaintSingleChildCommand paintCommand = PaintSingleChildCommand(
      owner: this, offset: offset, size: child.size,
      child: childPaintCommandGetter.getChildPaintCommand()!
    );

    this.paintCommand = paintCommand;

    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    late final double width;
    late final double height;

    if(axis == Axis.horizontal) {
      child.layout(Constraints(
          maxWidth: double.infinity,
          maxHeight: constraints.maxHeight,
      ));

      width = constraints.hasBoundedWidth ? constraints.maxWidth : child.size.width;
      height = child.size.height;
    }else {
      child.layout(Constraints(
          maxWidth: constraints.maxWidth,
          maxHeight: double.infinity,
      ));

      width = child.size.width;
      height = constraints.hasBoundedHeight ? constraints.maxHeight : child.size.height;
    }

    _scrolledOffset = Offset(
      topPos: (axis == Axis.vertical ? scrollController.position : 0).toDouble(),
      leftPos: (axis == Axis.horizontal ? scrollController.position : 0).toDouble(),
    );

    size = Size(
        width: width,
        height: height,
    );

    if(axis == Axis.horizontal) {
      scrollController.size = child.size.width;
    }else {
      scrollController.size = child.size.height;
    }
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => true;

  @override
  RenderBox get child => super.child! as RenderBox;
}