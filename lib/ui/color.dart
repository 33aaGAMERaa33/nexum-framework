class Color {
  final int red;
  final int green;
  final int blue;

  const Color({
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  bool operator ==(Object other) {
    return other is Color && other.red == red && other.green == green && other.blue == blue;
  }

  @override
  int get hashCode => Object.hash(red, green, blue);
}