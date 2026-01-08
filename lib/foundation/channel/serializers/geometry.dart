import '../../../painting/geometry.dart';
import '../friendly_buffer.dart';
import '../helper_serializer.dart';

class OffsetSerializer extends HelperSerializer<Offset> {
  @override
  String get identifier => "offset";

  @override
  Type get objectType => Offset;

  @override
  void serialize(Offset object, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeInt(object.leftPos.toInt());
    friendlyBuffer.writeInt(object.topPos.toInt());
  }
}

class SizeSerializer extends HelperSerializer<Size> {
  @override
  void serialize(Size object, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeInt(object.width.toInt());
    friendlyBuffer.writeInt(object.height.toInt());
  }

  @override
  String get identifier => "size";

  @override
  Type get objectType => Size;
}