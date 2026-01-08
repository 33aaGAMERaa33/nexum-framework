import 'package:nexum_framework/foundation/key.dart';

class ValueKey<T> extends Key{
  final T key;
  const ValueKey(this.key);

  @override
  bool operator ==(Object other) {
    return other is ValueKey && key == other.key;
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  @override
  String toString() => "ValueKey<$T> = $key";
}