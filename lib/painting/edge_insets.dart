class EdgeInsets {
  final double top;
  final double right;
  final double bottom;
  final double left;

  double get horizontalSize => left + right;
  double get verticalSize => top + bottom;

  const EdgeInsets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  const EdgeInsets.all(double value) :
        top = value,
        right = value,
        bottom = value,
        left = value;

  const EdgeInsets.symetric({double horizontal = 0, double vertical = 0}) :
        top= vertical,
        right= horizontal,
        bottom= vertical,
        left= horizontal;
}