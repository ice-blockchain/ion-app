import 'package:flutter/material.dart';

class PositionController with ChangeNotifier {
  double _position = 0;

  double get position => _position;

  void setPosition(double position) {
    _position = position;
    notifyListeners();
  }
}
