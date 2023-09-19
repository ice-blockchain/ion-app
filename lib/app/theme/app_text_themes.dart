import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

class AppTextThemesExtension extends ThemeExtension<AppTextThemesExtension> {
  const AppTextThemesExtension({
    required this.body1,
    required this.h1,
  });

  factory AppTextThemesExtension.fromTemplate(TemplateTextThemes textThemes) {
    return AppTextThemesExtension(
      body1: TextStyle(
        fontSize: textThemes.body1.fontSize,
        letterSpacing: textThemes.body1.letterSpacing,
      ),
      h1: TextStyle(
        fontSize: textThemes.h1.fontSize,
        letterSpacing: textThemes.h1.letterSpacing,
      ),
    );
  }

  final TextStyle body1;
  final TextStyle h1;

  @override
  ThemeExtension<AppTextThemesExtension> copyWith({
    TextStyle? body1,
    TextStyle? h1,
  }) {
    return AppTextThemesExtension(
      body1: body1 ?? this.body1,
      h1: h1 ?? this.h1,
    );
  }

  @override
  ThemeExtension<AppTextThemesExtension> lerp(
    covariant ThemeExtension<AppTextThemesExtension>? other,
    double t,
  ) {
    if (other is! AppTextThemesExtension) {
      return this;
    }

    return AppTextThemesExtension(
      body1: TextStyle.lerp(body1, other.body1, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
    );
  }
}

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appTextThemes;
  AppTextThemesExtension get appTextThemes =>
      extension<AppTextThemesExtension>()!;
}
