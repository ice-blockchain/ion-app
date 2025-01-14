// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(String color) : super(_getColorFromHex(color));
  static int _getColorFromHex(String hexColor) {
    var color = hexColor.toUpperCase().replaceAll('#', '');
    if (color.length == 6) {
      color = 'FF$color';
    }

    final hexNum = int.parse(color, radix: 16);

    if (hexNum == 0) {
      return 0xff000000;
    }

    return hexNum;
  }
}

extension IntColorComponents on Color {
  int get intAlpha => _floatToInt8(a);
  int get intRed => _floatToInt8(r);
  int get intGreen => _floatToInt8(g);
  int get intBlue => _floatToInt8(b);

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
