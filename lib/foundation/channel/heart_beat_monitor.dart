import 'dart:async';
import 'dart:io';

class HeartBeatMonitor {
  const HeartBeatMonitor._();

  static Timer ? timer;
  static bool _started = false;

  static void start(int enginePID) {
    assert(!_started);
    _started = true;

    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) async {
      if(await isProcessAlive(enginePID)) return;
      exit(0);
    },);
  }

  static Future<bool> isProcessAlive(int pid) async {
    if(Platform.isWindows) {
      final result = await Process.run(
        'tasklist', ['/FI', 'PID eq $pid'],
        runInShell: true,
      );
      return result.stdout.toString().contains('$pid');
    }else {
      try {
        return Process.killPid(pid);
      } catch (_) {
        return false;
      }
    }
  }
}