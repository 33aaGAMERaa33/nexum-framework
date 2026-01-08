import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../object.dart';
import '../painting.dart';

class RenderConstrainedBox extends RenderBox with SingleChildRenderObject {
  double ? width;
  double ? height;

  RenderConstrainedBox({
    required this.width,
    required this.height,
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
    child.layout(Constraints(maxWidth: width ?? double.infinity, maxHeight: height ?? double.infinity));
    size = Size(width: width ?? child.size.width, height: height ?? child.size.height);
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  bool get needsChildLayout => width == null || height == null;

  @override
  RenderBox get child => super.child! as RenderBox;
}