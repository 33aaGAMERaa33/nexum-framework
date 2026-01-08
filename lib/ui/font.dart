class Font {
  final int fontSize;

  const Font({
    required this.fontSize,
  });

  @override
  bool operator ==(Object other) {
    return other is Font && other.fontSize == fontSize;
  }

  @override
  int get hashCode => Object.hash(runtimeType, fontSize);
}