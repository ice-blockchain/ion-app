import 'package:flutter/material.dart';
import 'package:ice/app/theme/colors.dart';

ThemeData darkTheme = ThemeData(
  extensions: <ThemeExtension<dynamic>>[darkColors],
);

ThemeData lightTheme = ThemeData(
  extensions: <ThemeExtension<dynamic>>[lightColors],
);

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
