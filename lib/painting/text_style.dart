import 'package:nexum_framework/ui/color.dart';
import 'package:nexum_framework/material/colors.dart';
import 'package:nexum_framework/ui/font.dart';

class TextStyle {
  final Font font;
  final Color color;

  const TextStyle({
    this.font = const Font(fontSize: 16),
    this.color = Colors.black,
  });
}