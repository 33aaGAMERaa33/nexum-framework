import '../../../painting/geometry.dart';
import '../friendly_buffer.dart';
import '../helper_deserializer.dart';

class OffsetDeserializer extends HelperDeserializer<Offset> {
  @override
  Offset deserialize(FriendlyBuffer friendlyBuffer) {
    return Offset(
        leftPos: friendlyBuffer.readInt().toDouble(),
        topPos: friendlyBuffer.readInt().toDouble(),
    );
  }

  @override
  String get identifier => "offset";

  @override
  Type get objectType => Offset;
}

class SizeDeserializer extends HelperDeserializer<Size> {
  @override
  Size deserialize(FriendlyBuffer friendlyBuffer) => Size(
    width: friendlyBuffer.readInt().toDouble(),
    height: friendlyBuffer.readInt().toDouble(),
  );

  @override
  String get identifier => "size";

  @override
  Type get objectType => Size;
}