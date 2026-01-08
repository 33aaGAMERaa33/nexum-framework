class Size {
  final double width;
  final double height;
  const Size({required this.width, required this.height});

  Size operator +(Size other) {
    return Size(width: width + other.width, height: height + other.height);
  }

  @override
  bool operator ==(Object other) {
    return other is Size && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => "Size(width: $width, height: $height)";
}

class Offset {
  static const _zero = Offset(leftPos: 0, topPos: 0);
  final double leftPos;
  final double topPos;

  const Offset({
    required this.leftPos,
    required this.topPos,
  });

  factory Offset.zero() {
    return _zero;
  }

  bool isBefore(Offset other) {
    return leftPos < other.leftPos && topPos < other.topPos;
  }

  bool isAfter(Offset other) {
    return leftPos > other.leftPos && topPos > other.topPos;
  }

  @override
  String toString() => "Offset(leftPos: $leftPos, topPos: $topPos)";

  Offset operator +(Offset other) {
    return Offset(leftPos: leftPos + other.leftPos, topPos: topPos + other.topPos);
  }

  @override
  bool operator ==(Object other) {
    return other is Offset && other.leftPos == leftPos && other.topPos == topPos;
  }

  @override
  int get hashCode => Object.hash(leftPos, topPos);
}

class Rect {
  final Offset start;
  late final Offset end;
  late final Size size;

  Rect({required this.start, required this.end}) {
    assert(start.isBefore(end));
    size = Size(width: end.leftPos - start.leftPos, height: end.topPos - start.topPos);
  }

  Rect.fromSize({required this.start, required this.size}) {
    end = Offset(leftPos: start.leftPos + size.width, topPos: start.topPos + size.height);
    assert(start.isBefore(end), "$start -> $end");
  }

  bool contains(Offset offset) => start.isBefore(offset) && end.isAfter(offset);

  @override
  String toString() => "Rect(start: $start, end: $end, size: $size)";
}