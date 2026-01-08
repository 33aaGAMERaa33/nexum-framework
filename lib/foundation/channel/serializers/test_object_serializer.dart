import 'package:nexum_framework/models/test_object.dart';

import '../friendly_buffer.dart';
import '../helper_serializer.dart';

class TestObjectSerializer extends HelperSerializer<TestObject> {
  @override
  String get identifier => "test_object";

  @override
  Type get objectType => TestObject;

  @override
  void serialize(TestObject object, FriendlyBuffer friendlyBuffer) {
    friendlyBuffer.writeString(object.message);
  }
}