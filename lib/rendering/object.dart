import 'package:meta/meta.dart';
import 'package:nexum_framework/nexum.dart';
import 'package:nexum_framework/rendering/painting.dart';

import '../foundation/events/event.dart';
import '../painting/geometry.dart';
import '../widgets/framework.dart';
class Constraints {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  const Constraints({
    this.minWidth = 0,
    required this.maxWidth,
    this.minHeight = 0,
    required this.maxHeight,
  })  : assert(minWidth >= 0),
        assert(minHeight >= 0),
        assert(maxWidth >= minWidth),
        assert(maxHeight >= minHeight);

  /// Largura é limitada (não infinita)
  bool get hasBoundedWidth => maxWidth < double.infinity;

  /// Altura é limitada (não infinita)
  bool get hasBoundedHeight => maxHeight < double.infinity;

  /// Ambos os eixos são limitados
  bool get isBounded => hasBoundedWidth && hasBoundedHeight;

  /// Nenhum eixo é limitado
  bool get isUnbounded => !hasBoundedWidth && !hasBoundedHeight;

  /// Pelo menos um eixo é ilimitado
  bool get hasUnboundedAxis => !isBounded;

  /// Verifica se um tamanho cabe dentro das constraints
  bool allows(int width, int height) {
    return width >= minWidth &&
        width <= maxWidth &&
        height >= minHeight &&
        height <= maxHeight;
  }

  @override
  String toString() => "Constraints(minWidth: $minWidth, maxWidth: $maxWidth, minHeight: $minHeight, maxHeight: $maxHeight)";
}

abstract class RenderObject {
  Element ? _owner;
  @protected
  bool needsPaint = true;
  @protected
  bool needsLayout = true;
  @protected
  bool disposed = false;

  bool get isNeedsPaint => needsPaint;
  bool get isNeedsLayout => needsLayout;

  RenderObject ? parent;
  PaintCommand ? _paintCommand;

  Offset ? _absoluteOffset;
  Offset ? _relativeOffset;
  Constraints ? _constraints;

  set constraints(Constraints constraints) => _constraints = constraints;
  Constraints get constraints => _constraints!;

  @protected
  set paintCommand(PaintCommand ? paintCommand) {
    _paintCommand?.markDirty();
    _paintCommand = paintCommand;
  }

  @protected
  PaintCommand ? get paintCommand => _paintCommand;

  set absoluteOffset(Offset offset) => _absoluteOffset = offset;
  Offset get absoluteOffset => _absoluteOffset!;

  set relativeOffset(Offset offset) => _relativeOffset = offset;
  Offset get relativeOffset => _relativeOffset!;

  void update() {
    markNeedsPaint();
    markNeedsLayout();
  }

  void paint(PaintCommandRecorder paintRecorder, Offset offset);

  void repaint(PaintCommandRecorder paintRecorder) {
    if(!needsPaint) return;
    paint(paintRecorder, relativeOffset);
  }

  void layout(Constraints constraints);

  Future<void> relayout() async {
    if(!needsLayout) return;
    await prepareLayout();
    layout(constraints);
  }

  Future<void> prepareLayout();

  void propagateEvent<T extends Event>(T event);

  bool hitTest(Offset position);

  void markNeedsPaint() {
    if(needsPaint) return;
    needsPaint = true;
    _paintCommand?.markDirty();

    if(parent != null) {
      parent!.markNeedsPaint();
    }else {
      Nexum.instance.schedulePaintFor(this);
    }
  }

  void markNeedsLayout() {
    if(needsLayout) return;
    needsLayout = true;
    _paintCommand?.markDirty();

    if(parent != null && parent!.needsChildLayout) {
      parent!.markNeedsLayout();
    }else {
      Nexum.instance.scheduleLayoutFor(this);
    }
  }

  bool get needsChildLayout;

  void adoptChild(RenderObject child) {
    assert(child.parent == null);
    child.parent = this;
  }

  void dropChild(RenderObject child) {
    assert(child.parent == this);
    child.parent = null;
  }

  void updateChild(RenderObject oldChild, RenderObject newChild) {
    assert(oldChild.parent == this);
    assert(newChild.parent == null);

    oldChild.parent = null;
    newChild.parent = this;
  }

  void attach(Element owner) {
    assert(_owner == null);
    _owner = owner;
  }

  void deattach() {
    assert(_owner != null);
    _owner = null;
  }

  void dispose() {
    if(disposed) return;
    disposed = true;
    paintCommand?.markDirty();
  }
}