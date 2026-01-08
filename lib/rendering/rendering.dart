import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../painting/geometry.dart';
import '../ui/color.dart';
import '../ui/font.dart';

@immutable
abstract class RenderInstruction {
  static const _uuidFactory = Uuid();
  late final String uuid = _uuidFactory.v4();
  static final List<RenderInstruction> instructionsCache = [];

  static T getOrAdd<T extends RenderInstruction>(T instruction) {
    assert(instruction is! CreateContextInstruction);
    final int index = instructionsCache.indexOf(instruction);

    if(index == -1) {
      instructionsCache.add(instruction);
      return instruction;
    }

    return instructionsCache[index] as T;
  }

  static bool contains(RenderInstruction instruction) => instructionsCache.contains(instruction);
}

abstract class CreateContextInstruction extends RenderInstruction {
  final RenderContext _renderContext;
  RenderContext get renderContext => _renderContext;

  @protected
  CreateContextInstruction(this._renderContext);

  @override
  bool operator ==(Object other) {
    return other is CreateContextInstruction && other.renderContext == renderContext;
  }

  @override
  int get hashCode => Object.hash(runtimeType, renderContext);
}

class CreateSubContextInstruction extends CreateContextInstruction {
  CreateSubContextInstruction(super.renderContext);
}

class ClipRectInstruction extends RenderInstruction {
  final Size size;
  final Offset offset;

  ClipRectInstruction._(this.offset, this.size);

  factory ClipRectInstruction(Offset offset, Size size) {
    return RenderInstruction.getOrAdd(
      ClipRectInstruction._(offset, size),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClipRectInstruction &&
        other.size == size &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(runtimeType, size, offset);
}

class DrawStringInstruction extends RenderInstruction {
  final String string;

  DrawStringInstruction._(this.string);

  factory DrawStringInstruction(String string) {
    return RenderInstruction.getOrAdd(
      DrawStringInstruction._(string),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DrawStringInstruction && other.string == string;
  }

  @override
  int get hashCode => Object.hash(runtimeType, string);
}

class DrawRectInstruction extends RenderInstruction {
  final Size size;

  DrawRectInstruction._(this.size);

  factory DrawRectInstruction(Size size) {
    final adjusted = Size(
      width: size.width - 1,
      height: size.height - 1,
    );

    return RenderInstruction.getOrAdd(
      DrawRectInstruction._(adjusted),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DrawRectInstruction && other.size == size;
  }

  @override
  int get hashCode => Object.hash(runtimeType, size);
}

class TranslateInstruction extends RenderInstruction {
  final Offset offset;

  TranslateInstruction._(this.offset);

  factory TranslateInstruction(Offset offset) {
    return RenderInstruction.getOrAdd(
      TranslateInstruction._(offset),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TranslateInstruction && other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(runtimeType, offset);
}

class SetFontInstruction extends RenderInstruction {
  final Font font;

  SetFontInstruction._(this.font);

  factory SetFontInstruction(Font font) {
    return RenderInstruction.getOrAdd(
      SetFontInstruction._(font),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetFontInstruction && other.font == font;
  }

  @override
  int get hashCode => Object.hash(runtimeType, font);
}

class SetColorInstruction extends RenderInstruction {
  final Color color;

  SetColorInstruction._(this.color);

  factory SetColorInstruction(Color color) {
    return RenderInstruction.getOrAdd(
      SetColorInstruction._(color),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetColorInstruction && other.color == color;
  }

  @override
  int get hashCode => Object.hash(runtimeType, color);
}

class SetCompositeInstruction extends RenderInstruction {
  final double alpha;

  SetCompositeInstruction._(this.alpha);

  factory SetCompositeInstruction(double alpha) {
    return RenderInstruction.getOrAdd(
      SetCompositeInstruction._(alpha),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetCompositeInstruction && other.alpha == alpha;
  }

  @override
  int get hashCode => Object.hash(runtimeType, alpha);
}

class RenderContext {
  static const _eq = ListEquality();
  static final List<RenderInstruction> _cache = [];
  
  final RenderContext ? _parent;
  final List<RenderInstruction> _instructions = [];
  late final List<RenderInstruction> _newsInstructions;

  List<RenderInstruction> get instructions => List.unmodifiable(_instructions);
  List<RenderInstruction> get newInstructions => List.unmodifiable(_newsInstructions);

  RenderContext() : _parent = null, _newsInstructions = [];
  
  RenderContext._(RenderContext parent) : _parent = parent {
    _newsInstructions = parent._newsInstructions;
  }

  void _addInstruction(RenderInstruction instruction) {
    if(!_cache.contains(instruction) && instruction is! CreateContextInstruction) {
      _newsInstructions.add(instruction);
      _cache.add(instruction);
    }

    if(_instructions.contains(instruction)) return;
    _instructions.add(instruction);
  }

  RenderContext create() {
    final RenderContext renderContext = RenderContext._(this);
    _addInstruction(CreateSubContextInstruction(renderContext));

    return renderContext;
  }

  RenderContext createScoped(Offset offset, Size size) {
    final RenderContext renderContext = RenderContext();

    renderContext.translate(offset);
    renderContext.clipRect(Offset.zero(), size);

    return renderContext;
  }

  void setFont(Font font) => _addInstruction(SetFontInstruction(font));
  void drawRect(Size size) => _addInstruction(DrawRectInstruction(size));
  void setColor(Color color) => _addInstruction(SetColorInstruction(color));
  void translate(Offset offset) => _addInstruction(TranslateInstruction(offset));
  void drawString(String string) => _addInstruction(DrawStringInstruction(string));
  void setComposite(double alpha) => _addInstruction(SetCompositeInstruction(alpha));
  void clipRect(Offset offset, Size size) => _addInstruction(ClipRectInstruction(offset, size));

  @override
  bool operator ==(Object other) {
    return other is RenderContext && _eq.equals(other._instructions, _instructions);
  }

  @override
  int get hashCode => Object.hash(runtimeType, _eq.hash(_instructions));
}