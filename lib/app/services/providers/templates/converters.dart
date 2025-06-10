// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:ion/app/extensions/color.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    final buffer = StringBuffer();
    if (json.length == 6 || json.length == 7) buffer.write('ff');
    buffer.write(json.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  String toJson(Color color) => '#'
      '${color.intAlpha.toRadixString(16).padLeft(2, '0')}'
      '${color.intRed.toRadixString(16).padLeft(2, '0')}'
      '${color.intGreen.toRadixString(16).padLeft(2, '0')}'
      '${color.intBlue.toRadixString(16).padLeft(2, '0')}';
}

class FontWeightConverter implements JsonConverter<FontWeight, int> {
  const FontWeightConverter();

  @override
  FontWeight fromJson(int json) {
    return switch (json) {
      100 => FontWeight.w100,
      200 => FontWeight.w200,
      300 => FontWeight.w300,
      400 => FontWeight.w400,
      500 => FontWeight.w500,
      600 => FontWeight.w600,
      700 => FontWeight.w700,
      800 => FontWeight.w800,
      900 => FontWeight.w900,
      _ => FontWeight.w400,
    };
  }

  @override
  int toJson(FontWeight fontWeight) => fontWeight.value;
}
