import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.background,
  });

  factory AppColorsExtension.fromTemplate(TemplateColors templateColors) {
    return AppColorsExtension(
      background: Color(templateColors.background),
      primary: Color(templateColors.primary),
    );
  }

  final Color primary;
  final Color background;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? background,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      background: background ?? this.background,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors => extension<AppColorsExtension>()!;
}
