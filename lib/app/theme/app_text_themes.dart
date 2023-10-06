import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

class AppTextThemesExtension extends ThemeExtension<AppTextThemesExtension> {
  const AppTextThemesExtension({
    required this.headline1,
    required this.inputFieldText,
    required this.title,
    required this.subtitle,
    required this.subtitle2,
    required this.body,
    required this.body2,
    required this.caption,
    required this.caption2,
    required this.caption3,
  });

  factory AppTextThemesExtension.fromTemplate(TemplateTextThemes textThemes) {
    return AppTextThemesExtension(
      headline1: TemplateTextStyle.fromTemplate(textThemes.headline1),
      inputFieldText: TemplateTextStyle.fromTemplate(textThemes.inputFieldText),
      title: TemplateTextStyle.fromTemplate(textThemes.title),
      subtitle: TemplateTextStyle.fromTemplate(textThemes.subtitle),
      subtitle2: TemplateTextStyle.fromTemplate(textThemes.subtitle2),
      body: TemplateTextStyle.fromTemplate(textThemes.body),
      body2: TemplateTextStyle.fromTemplate(textThemes.body2),
      caption: TemplateTextStyle.fromTemplate(textThemes.caption),
      caption2: TemplateTextStyle.fromTemplate(textThemes.caption2),
      caption3: TemplateTextStyle.fromTemplate(textThemes.caption3),
    );
  }

  final TextStyle headline1;
  final TextStyle inputFieldText;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle subtitle2;
  final TextStyle body;
  final TextStyle body2;
  final TextStyle caption;
  final TextStyle caption2;
  final TextStyle caption3;

  @override
  ThemeExtension<AppTextThemesExtension> copyWith({
    TextStyle? headline1,
    TextStyle? inputFieldText,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? subtitle2,
    TextStyle? body,
    TextStyle? body2,
    TextStyle? caption,
    TextStyle? caption2,
    TextStyle? caption3,
  }) {
    return AppTextThemesExtension(
      headline1: headline1 ?? this.headline1,
      inputFieldText: inputFieldText ?? this.inputFieldText,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      subtitle2: subtitle2 ?? this.subtitle2,
      body: body ?? this.body,
      body2: body2 ?? this.body2,
      caption: caption ?? this.caption,
      caption2: caption2 ?? this.caption2,
      caption3: caption3 ?? this.caption3,
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
      headline1: TextStyle.lerp(headline1, other.headline1, t)!,
      inputFieldText: TextStyle.lerp(inputFieldText, other.inputFieldText, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      subtitle2: TextStyle.lerp(subtitle2, other.subtitle2, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      body2: TextStyle.lerp(body2, other.body2, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      caption2: TextStyle.lerp(caption2, other.caption2, t)!,
      caption3: TextStyle.lerp(caption3, other.caption3, t)!,
    );
  }
}

class TemplateTextStyle extends TextStyle {
  static TextStyle fromTemplate(TemplateTextTheme theme) {
    return TextStyle(
      fontSize: theme.fontSize,
      fontWeight: theme.fontWeight,
      height: theme.height,
    );
  }
}
