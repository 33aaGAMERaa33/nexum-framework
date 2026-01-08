import 'package:nexum_framework/exceptions/incorrect_render_object_update.dart';

import '../painting/text_style.dart';
import '../rendering/object.dart';
import '../rendering/renderers/render_paragraph.dart';
import 'framework.dart';

class RichText extends LeafChildRenderObjectWidget {
  final String value;
  final TextStyle style;

  const RichText(this.value, {
    this.style = const TextStyle()
  });

  @override
  RenderObject createRenderObject() => RenderParagraph(
    value: value,
    style: style
  );

  @override
  void updateRenderObject(RenderObject renderObject) {
    if(renderObject is! RenderParagraph) throw IncorrectRenderObjectUpdate(renderObject, RenderParagraph);
    //Logger.log("identifier", "old: ${renderObject.value} new: $value");

    renderObject.value = value;
    renderObject.style = style;
    renderObject.update();
  }

  @override
  String toString() => "RichText(value: $value)";
}