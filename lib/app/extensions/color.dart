// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

extension IntColorComponents on Color {
  int get intAlpha => _floatToInt8(a);
  int get intRed => _floatToInt8(r);
  int get intGreen => _floatToInt8(g);
  int get intBlue => _floatToInt8(b);

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
