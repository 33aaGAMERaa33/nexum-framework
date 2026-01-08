import 'package:nexum_framework/rendering/rendering.dart';
import 'package:uuid/uuid.dart';

import '../painting/geometry.dart';
import 'object.dart';

abstract class PaintCommand {
  RenderObject owner;
  bool _dirty = false;
  final Size size;
  final Offset offset;
  final String uuid = uuidFactory.v4();
  static const Uuid uuidFactory = Uuid();

  bool get dirty => _dirty;

  PaintCommand({
    required this.owner,
    required this.size,
    required this.offset,
  });

  void paint(RenderContext renderContext);

  void markDirty() {
    if(_dirty) return;
    _dirty = true;
  }
}

abstract class PaintCommandRecorder {
  void register(PaintCommand paintCommand);
}

class PaintContext implements PaintCommandRecorder {
  final List<PaintCommand> paintCommands = [];

  void paint(RenderContext renderContext) {
    for(final PaintCommand paintCommand in paintCommands) {
      paintCommand.paint(renderContext);
    }
  }

  @override
  void register(PaintCommand paintCommand) {
    if(paintCommands.contains(paintCommand)) return;
    paintCommands.add(paintCommand);
  }
}

class PaintSingleChildCommand extends PaintCommand {
  final PaintCommand ? child;

  PaintSingleChildCommand({
    required super.owner,
    required super.size,
    required super.offset,
    required this.child,
  });

  @override
  void paint(RenderContext renderContext) {
    if(child == null) return;
    renderContext.translate(offset);
    renderContext.clipRect(Offset.zero(), size);

    final RenderContext subContext = renderContext.create();
    child?.paint(subContext);
  }
}

class PaintMultiChildCommand extends PaintCommand {
  final List<PaintCommand> childrens;

  PaintMultiChildCommand({
    required super.owner,
    required super.size,
    required super.offset,
    required this.childrens
  });

  @override
  void paint(RenderContext renderContext) {
    renderContext.translate(offset);
    renderContext.clipRect(Offset.zero(), size);
    final RenderContext subContext = renderContext.create();

    for(final PaintCommand child in childrens) {
      final RenderContext childContext = subContext.create();
      child.paint(childContext);
    }
  }
}