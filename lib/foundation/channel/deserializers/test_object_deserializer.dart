import 'package:nexum_framework/models/test_object.dart';

import '../friendly_buffer.dart';
import '../helper_deserializer.dart';

class TestObjectDeserializer extends HelperDeserializer<TestObject> {
  @override
  String get identifier => "test_object";

  @override
  Type get objectType => TestObject;

  @override
  TestObject deserialize(FriendlyBuffer friendlyBuffer) {
    return TestObject(friendlyBuffer.readString());
  }
}