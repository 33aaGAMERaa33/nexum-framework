import 'package:nexum_framework/ui/font.dart';

import '../../../ui/color.dart';
import '../friendly_buffer.dart';
import '../helper_serializer.dart';

class ColorSerializer extends HelperSerializer<Color> {
  @override
  String get identifier => "color";

  @override
  Type get objectType => Color;

  @override
  void serialize(Color object, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeInt(object.red);
    friendlyBuffer.writeInt(object.green);
    friendlyBuffer.writeInt(object.blue);
  }
}

class FontSerializer extends HelperSerializer<Font> {
  @override
  void serialize(Font object, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeInt(object.fontSize);
  }

  @override
  String get identifier => "font";

  @override
  Type get objectType => Font;
}