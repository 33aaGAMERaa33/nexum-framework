import 'package:nexum_framework/models/test_object.dart';

import '../packet.dart';

class TestPacket extends Packet {
  final TestObject testObject;
  TestPacket(this.testObject);

  @override
  String toString() => "TestPacket(testObject: $testObject)";
}