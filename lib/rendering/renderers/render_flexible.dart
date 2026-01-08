
import 'package:nexum_framework/rendering/renderers/render_flex.dart';

import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../object.dart';
import '../painting.dart';

class RenderFlexible extends RenderBox with SingleChildRenderObject {
  int flex;
  FlexFit flexFit;
  RenderFlexible({
    required this.flex,
    required this.flexFit,
  });

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    child.absoluteOffset = absoluteOffset;
    relativeOffset = offset;

    final GetChildPaintCommand childPaintCommandGetter = GetChildPaintCommand();

    child.paint(childPaintCommandGetter, Offset.zero());

    final PaintSingleChildCommand paintCommand = PaintSingleChildCommand(
        owner: this, offset: offset, size: size,
        child: childPaintCommandGetter.getChildPaintCommand()
    );

    this.paintCommand = paintCommand;

    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    child.layout(Constraints(
        maxWidth: constraints.maxWidth,
        minWidth: flexFit == FlexFit.tight ? constraints.maxWidth : 0,
        maxHeight: constraints.maxHeight,
        minHeight: flexFit == FlexFit.tight ? constraints.minHeight : 0,
    ));

    size = Size(width: constraints.maxWidth, height: constraints.maxHeight);
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => false;

  @override
  RenderObject get child => super.child!;
}