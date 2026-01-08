import 'dart:async';
import 'dart:io';

class HeartbeatMonitor {
  static Timer? _timer;
  static const timeout = Duration(milliseconds: 10_000);
  static DateTime _lastSeen = DateTime.now();

  static void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if(DateTime.now().difference(_lastSeen) > timeout) {
        exit(0);
      }
    });
  }

  static void onHeartbeat() {
    _lastSeen = DateTime.now();
  }
}
