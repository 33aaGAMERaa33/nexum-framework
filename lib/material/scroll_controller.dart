class ScrollController {
  int _position = 0;
  int _scrollAmount = 50;

  int get position => _position;
  int get moreScrollAmount => _scrollAmount;

  void addScroll(int amount) {
    _position += amount;
  }
}