import 'package:nexum_framework/widgets/sized_box.dart';

import '../exceptions/incorrect_render_object_update.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_flex.dart';
import '../rendering/renderers/render_flexible.dart';
import 'framework.dart';

class Flexible extends SingleChildRenderObjectWidget {
  final int flex;
  final FlexFit flexFit;

  const Flexible({
    this.flex = 1,
    this.flexFit = FlexFit.loose,
    required super.child,
  });

  @override
  RenderObject createRenderObject() => RenderFlexible(flex: flex, flexFit: flexFit);

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderFlexible) throw IncorrectRenderObjectUpdate(renderObject, RenderFlexible);

    renderObject.flex = flex;
    renderObject.flexFit = flexFit;
    renderObject.update();
  }
}

class Expanded extends Flexible {
  const Expanded({
    super.flex = 1,
    required super.child,
  }) : super(flexFit: FlexFit.tight);
}

class Spacing extends Expanded {
  const Spacing({super.flex = 1}) : super(child: const SizedBox());
}