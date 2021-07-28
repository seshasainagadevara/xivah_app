import 'package:flutter/foundation.dart';

class OnBoardingPagesNotifier extends ChangeNotifier {
  int _position;

  OnBoardingPagesNotifier(this._position) {
    controlDots(this._position);
  }

  controlDots(int pos) {
    this._position = pos;
    notifyListeners();
  }

  int get position => _position;
}
