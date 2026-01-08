import 'package:nexum_framework/ui/color.dart';
import 'package:nexum_framework/ui/font.dart';

import '../../painting/geometry.dart';
import '../painting.dart';
import '../rendering.dart';

class PaintParagraphCommand extends PaintCommand {
  final Font font;
  final Color color;
  final String value;

  PaintParagraphCommand({
    required super.owner,
    required super.size,
    required super.offset,
    required this.value,
    required this.font,
    required this.color,
  });

  @override
  void paint(RenderContext renderContext) {
    renderContext.translate(offset);
    renderContext.clipRect(Offset.zero(), size);

    renderContext.setFont(font);
    renderContext.setColor(color);
    renderContext.drawString(value);
  }
}