import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

IconThemeData buildIconTheme(Template template) {
  final double averageSize = (template.icon.width + template.icon.height) / 2;

  return IconThemeData(
    size: averageSize,
    // color: iconButtonTheme.iconTintColor,
  );
}
