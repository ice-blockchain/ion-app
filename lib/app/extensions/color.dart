import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(String color) : super(_getColorFromHex(color));
  static int _getColorFromHex(String hexColor) {
    String color = hexColor.toUpperCase().replaceAll('#', '');
    if (color.length == 6) {
      color = 'FF$color';
    }

    final int hexNum = int.parse(color, radix: 16);

    if (hexNum == 0) {
      return 0xff000000;
    }

    return hexNum;
  }
}

class ColorToHex extends Color {
  ColorToHex(Color color) : super(_convertColorTHex(color));

  ///convert material colors to hex color
  static int _convertColorTHex(Color color) {
    final String hex = '${color.value}';
    return int.parse(
      hex,
    );
  }
}
