enum Alignment {
  topLeft(0, 0),
  topCenter(0, 0.5),
  topRight(0, 1),

  centerLeft(0.5, 0),
  center(0.5, 0.5),
  centerRight(0.5, 1),

  bottomLeft(1, 0),
  bottomCenter(1, 0.5),
  bottomRight(1, 1);

  final double xFactor;
  final double yFactor;

  const Alignment(this.yFactor,  this.xFactor);
}
