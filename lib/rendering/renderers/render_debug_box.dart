import 'package:nexum_framework/rendering/commands/paint_rect_command.dart';

import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../painting.dart';

class RenderDebugBox extends RenderBox with SingleChildRenderObject {
  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    relativeOffset = offset;

    if(child.needsPaint) {
      child.absoluteOffset = absoluteOffset;
      child.paint(FakePaintCommandRecorder(), Offset.zero());
    }

    final PaintMultiChildCommand paintCommand = PaintMultiChildCommand(
        owner: this, offset: offset, size: size,
        childrens: [
          child.paintCommand!,
          PaintRectCommand(
              size: size,
              owner: this,
              offset: Offset.zero(),
          ),
        ]
    );

    this.paintCommand = paintCommand;

    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    if(child.needsLayout) child.layout(constraints);
    size = Size(width: child.size.width, height: child.size.height);
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  RenderBox get child => super.child! as RenderBox;

  @override
  bool get needsChildLayout => true;
}