import 'package:flutter/material.dart';
import 'package:ice/app/theme/app_bar_theme.dart';
import 'package:ice/app/theme/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  extensions: <ThemeExtension<dynamic>>[lightColors],
  appBarTheme: lightAppBarTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  extensions: <ThemeExtension<dynamic>>[darkColors],
  appBarTheme: darkAppBarTheme,
);

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
