import 'dart:math';

import 'package:nexum_framework/painting/axis.dart';

import '../foundation/change_notifier.dart';
import '../nexum.dart';

class ScrollController extends ChangeNotifier {
  Axis axis;
  double size = 0;
  double get sizeCompensation => axis == Axis.horizontal ? Nexum.instance.screenSize.width : Nexum.instance.screenSize.height;

  double attrition = 1;
  double scrollAmount = 100;
  double minimumAttrition = 0.1;
  double negationOfFrictionByMomentumValue = 0;

  double velocity = 1000;

  double _position = 0.0;
  double _remaining = 0;

  bool scrolling = false;

  double get position => _position;

  ScrollController({this.axis = Axis.vertical});

  void animateBy(double scrollDelta) {
    _remaining += scrollDelta * scrollAmount;

    if(scrolling) return;
    scrolling = true;

    Nexum.instance.addPersistentFrameCallback(_onFrame);
  }

  void animateTo(double position) {
    _remaining = position - _position;

    if(scrolling) return;
    scrolling = true;

    Nexum.instance.addPersistentFrameCallback(_onFrame);
  }

  void _onFrame(double delta) {
    assert(velocity > 0);
    assert(attrition > 0);
    assert(scrollAmount > 0);
    assert(minimumAttrition > 0);
    assert(negationOfFrictionByMomentumValue >= 0);

    if(_remaining.abs() < 0.01) {
      _remaining = 0;
      scrolling = false;
      Nexum.instance.cancelPersistentFrameCallback(_onFrame);
      return;
    }


    final double movimentationValue = (_remaining / scrollAmount * velocity).abs();
    final double dir = _remaining.sign * delta * movimentationValue;

    final double attritionNegation = movimentationValue / velocity * negationOfFrictionByMomentumValue;
    final double attritionValue = max(minimumAttrition, attrition - attritionNegation);

    final double finalMovimentValue = dir * attritionValue * -1;

    _position += dir;
    _remaining += finalMovimentValue;

    if(_position.isNegative && _position.abs() + sizeCompensation > size) {
      _remaining = 0;
      animateTo((size - sizeCompensation) * -1);
    }else if(!_position.isNegative && _position > 0){
      _remaining = 0;
      animateTo(0);
    }

    notifyListeners();
  }

  void jumpTo(double position) {
    cancelScroll();
    _remaining = 0;
    _position = position;
    notifyListeners();
  }

  void cancelScroll() {
    if(!scrolling) return;
    scrolling = false;
    _remaining = 0;
    Nexum.instance.cancelPersistentFrameCallback(_onFrame);
  }
}
