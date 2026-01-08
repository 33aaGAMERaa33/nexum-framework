import '../../painting/geometry.dart';
import '../box.dart';
import '../mixins/single_child_render_object.dart';
import '../object.dart';
import '../painting.dart';

class RenderView extends RenderBox with SingleChildRenderObject {
  @override
  RenderObject get child => super.child!;

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    child.absoluteOffset = absoluteOffset;
    relativeOffset = offset;

    child.paint(paintRecorder, offset);
  }

  @override
  void performLayout() {
    child.layout(constraints);
    size = Size(width: constraints.maxWidth, height: constraints.maxHeight);
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => false;
}