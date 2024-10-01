// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_text_themes.dart';

IconButtonThemeData buildIconButtonTheme(
  TemplateTheme templateTheme,
  AppTextThemesExtension textThemes,
) {
  return IconButtonThemeData(
    style: ButtonStyle(
      fixedSize: WidgetStateProperty.all<Size>(
        Size(
          templateTheme.iconButton.width.s,
          templateTheme.iconButton.height.s,
        ),
      ),
      iconSize: WidgetStateProperty.all<double>(
        templateTheme.iconButton.width.s,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}
