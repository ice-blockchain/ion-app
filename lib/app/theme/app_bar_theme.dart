import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/theme/colors.dart';
import 'package:ice/app/theme/text_styles.dart';

AppBarTheme appBarTheme = const AppBarTheme(
  toolbarHeight: 40,
);

AppBarTheme lightAppBarTheme = appBarTheme.copyWith(
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  backgroundColor: lightColors.background,
  titleTextStyle: AppTypography.body1.copyWith(color: lightColors.primary),
);

AppBarTheme darkAppBarTheme = appBarTheme.copyWith(
  systemOverlayStyle: SystemUiOverlayStyle.light,
  backgroundColor: darkColors.background,
  titleTextStyle: AppTypography.body1.copyWith(color: darkColors.primary),
);
