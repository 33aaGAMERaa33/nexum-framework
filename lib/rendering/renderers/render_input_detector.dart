import 'package:nexum_framework/foundation/events/input_events.dart';

import '../../painting/geometry.dart';
import '../box.dart';
import '../helpers/get_child_paint_command.dart';
import '../mixins/on_input.dart';
import '../mixins/single_child_render_object.dart';
import '../painting.dart';

typedef InputHandle = void Function(InputEvent event);

class RenderInputDetector extends RenderBox with SingleChildRenderObject, OnPointerTap {
  InputHandle callback;
  RenderInputDetector(this.callback);

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

    final PaintSingleChildCommand paintCommand = PaintSingleChildCommand(
      owner: this, child: child.paintCommand!,
      offset: offset, size: size,
    );

    this.paintCommand = paintCommand;
    paintRecorder.register(paintCommand);
  }

  @override
  void performLayout() {
    if(child.needsLayout) child.layout(constraints);
    size = child.size;
  }

  @override
  Future<void> prepareLayout() => child.prepareLayout();

  @override
  void onInput(InputEvent event) {
    callback.call(event);
  }

  @override
  bool get needsChildLayout => true;

  @override
  RenderBox get child => super.child! as RenderBox;
}