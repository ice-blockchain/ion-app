import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_typography.dart';

AppBarTheme buildLightAppBarTheme(Template template) {
  return const AppBarTheme().copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    toolbarHeight: template.appBar.toolbarHeight,
    backgroundColor: Color(template.colors.light.background),
    titleTextStyle: AppTypography.body1
        .copyWith(color: Color(template.colors.light.primary)),
  );
}

AppBarTheme buildDarkAppBarTheme(Template template) {
  return const AppBarTheme().copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    toolbarHeight: template.appBar.toolbarHeight,
    backgroundColor: Color(template.colors.dark.background),
    titleTextStyle: AppTypography.body1
        .copyWith(color: Color(template.colors.dark.primary)),
  );
}
