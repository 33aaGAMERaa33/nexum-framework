import 'dart:math';

import 'package:meta/meta.dart';

import '../../painting/alignament.dart';
import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../painting.dart';

class RenderAlign extends RenderBox with SingleChildRenderObject {
  Alignment alignment;
  Offset ? _alignedOffset;

  @override
  @protected
  RenderBox get child => super.child! as RenderBox;

  RenderAlign(this.alignment);

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    child.absoluteOffset = absoluteOffset + _alignedOffset!;
    relativeOffset = offset;

    final GetChildPaintCommand childPaintCommandGetter = GetChildPaintCommand();
    child.paint(childPaintCommandGetter, Offset.zero());

    final PaintCommand paintCommand = PaintSingleChildCommand(
      owner: this,
      size: size,
      offset: offset + _alignedOffset!,
      child: childPaintCommandGetter.getChildPaintCommand(),
    );

    this.paintCommand = paintCommand;

    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    child.layout(constraints);

    final Size childSize = child.size;
    final double width = constraints.hasBoundedWidth ? constraints.maxWidth : child.size.width;
    final double height = constraints.hasBoundedHeight ? constraints.maxHeight : child.size.height;

    final double alignedX = (width - childSize.width) * alignment.xFactor;
    final double alignedY = (height - childSize.height) * alignment.yFactor;

    size = Size(
        width: width,
        height: height
    );

    _alignedOffset = Offset(
        leftPos: min(alignedX, width),
        topPos: min(alignedY, height),
    );
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => true;
}
