import '../../painting/edge_insets.dart';
import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/single_child_render_object.dart';
import '../object.dart';
import '../painting.dart';

class RenderPadding extends RenderBox with SingleChildRenderObject {
  EdgeInsets edgeInsets;
  Offset ? translatedOffset;
  RenderPadding(this.edgeInsets);

  @override
  void paint(PaintCommandRecorder paintRecorder, Offset offset) {
    if(!needsPaint) return;
    needsPaint = false;

    if(parent == null) absoluteOffset = offset;
    child.absoluteOffset = absoluteOffset + translatedOffset!;
    relativeOffset = offset;

    final GetChildPaintCommand childPaintCommandGetter = GetChildPaintCommand();

    child.paint(childPaintCommandGetter, translatedOffset!);

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
        maxWidth: constraints.maxWidth - edgeInsets.horizontalSize,
        maxHeight: constraints.maxHeight - edgeInsets.verticalSize,
    ));

    size = Size(
        width: child.size.width + edgeInsets.horizontalSize,
        height: child.size.height + edgeInsets.verticalSize,
    );

    translatedOffset = Offset(leftPos: edgeInsets.left, topPos: edgeInsets.top);
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  RenderBox get child => super.child! as RenderBox;

  @override
  bool get needsChildLayout => true;
}