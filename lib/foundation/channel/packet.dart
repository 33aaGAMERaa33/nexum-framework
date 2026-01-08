import 'package:uuid/uuid.dart';

class Packet {
  String ? _uuid;
  static const Uuid uuidFactory = Uuid();

  set uuid(String uuid) {
    assert(_uuid == null);
    _uuid = uuid;
  }

  String ? get uuid => _uuid;

  @override
  String toString() => "Packet(uuid: $uuid)";
}