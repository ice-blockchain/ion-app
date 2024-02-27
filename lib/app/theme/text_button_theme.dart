import 'package:flutter/material.dart';

TextButtonThemeData buildTextButtonTheme() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
    ),
  );
}
