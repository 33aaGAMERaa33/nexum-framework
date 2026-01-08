import '../painting/geometry.dart';
import 'object.dart';

abstract class RenderBox extends RenderObject {
  Size ? _size;

  set size(Size size) => _size = size;
  Size get size => _size!;

  @override
  void layout(Constraints constraints) {
    if(!needsLayout) return;
    needsLayout = false;
    this.constraints = constraints;
    performLayout();
  }

  void performLayout();

  @override
  bool hitTest(Offset position) {
    final Rect rect = Rect.fromSize(start: absoluteOffset, size: size);
    return rect.contains(position);
  }
}