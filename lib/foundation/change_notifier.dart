import 'package:meta/meta.dart';
import 'package:nexum_framework/foundation/types/void_callback.dart';

abstract class Listenable {
  const Listenable();

  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
}

mixin class ChangeNotifier implements Listenable {
  final List<VoidCallback> _listeners = [];
  bool _disposed = false;

  bool get disposed => _disposed;

  @protected
  void notifyListeners() {
    assert(!_disposed);
    for(final VoidCallback listener in _listeners) {
      listener.call();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    assert(!_disposed);
    if(_listeners.contains(listener)) return;
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(!_disposed);
    _listeners.remove(listener);
  }

  void dispose() {
    assert(!_disposed);
    _disposed = true;
    _listeners.clear();
  }
}