import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';

import '../foundation/types/void_callback.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_input_detector.dart';
import 'framework.dart';

class InputDetector extends SingleChildRenderObjectWidget {
  final InputHandle onInput;

  InputDetector({
    required this.onInput,
    required super.child,
  });

  @override
  RenderObject createRenderObject() => RenderInputDetector(onInput);

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderInputDetector) throw IncorrectRenderObjectUpdate(renderObject, RenderInputDetector);

    renderObject.callback = onInput;
    renderObject.update();
  }
}