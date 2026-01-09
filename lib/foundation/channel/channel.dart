import 'dart:io';
import 'dart:typed_data';

import 'package:nexum_framework/foundation/channel/friendly_buffer.dart';
import 'package:nexum_framework/foundation/channel/packet_manager.dart';

class Channel {
  static Channel ? _instance;
  final PacketManager packetManager;

  bool _isRunning = false;
  final BytesBuilder _buffer = BytesBuilder();

  static Channel get instance => _instance!;
  static bool get initialized => _instance != null;

  Channel._({
    required this.packetManager,
  });

  static Channel initialize({
    required PacketManager packetManager,
  }) => _instance = Channel._(
    packetManager: packetManager,
  );

  void start() {
    if(_isRunning) return;
    _isRunning = true;
    stdin.listen(_onData);
  }

  void _onData(List<int> chunk) {
    _buffer.add(chunk);
    _handleReceivedData();
  }

  void _handleReceivedData() {
    while(true) {
      final bytes = _buffer.toBytes();
      if (bytes.length < 4) return;

      final size =
      (bytes[0] << 24) |
      (bytes[1] << 16) |
      (bytes[2] << 8) |
      bytes[3];

      if (bytes.length < 4 + size) return;

      final payload = bytes.sublist(4, 4 + size);
      final FriendlyBuffer friendlyBuffer = FriendlyBuffer.fromBytes(payload);

      packetManager.handleReceivedData(friendlyBuffer);

      _buffer.clear();
      _buffer.add(bytes.sublist(4 + size));
    }
  }

  void send(List<int> payload) {
    final ByteData lengthData = ByteData(4);
    lengthData.setUint32(0, payload.length, Endian.little);

    stdout.add(lengthData.buffer.asUint8List());
    stdout.add(payload);
  }
}
