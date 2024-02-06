import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primaryAccent,
    required this.primaryText,
    required this.secondaryText,
    required this.tertararyText,
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.tertararyBackground,
    required this.backgroundSheet,
    required this.onPrimaryAccent,
    required this.onTertararyBackground,
    required this.onTerararyFill,
    required this.onSecondaryBackground,
    required this.strokeElements,
    required this.sheetLine,
    required this.attentionRed,
    required this.success,
  });

  factory AppColorsExtension.fromTemplate(TemplateColors templateColors) {
    return AppColorsExtension(
      primaryAccent: templateColors.primaryAccent,
      primaryText: templateColors.primaryText,
      secondaryText: templateColors.secondaryText,
      tertararyText: templateColors.tertararyText,
      primaryBackground: templateColors.primaryBackground,
      secondaryBackground: templateColors.secondaryBackground,
      tertararyBackground: templateColors.tertararyBackground,
      backgroundSheet: templateColors.backgroundSheet,
      onPrimaryAccent: templateColors.onPrimaryAccent,
      onTertararyBackground: templateColors.onTertararyBackground,
      onTerararyFill: templateColors.onTerararyFill,
      onSecondaryBackground: templateColors.onSecondaryBackground,
      strokeElements: templateColors.strokeElements,
      sheetLine: templateColors.sheetLine,
      attentionRed: templateColors.attentionRed,
      success: templateColors.success,
    );
  }

  final Color primaryAccent;
  final Color primaryText;
  final Color secondaryText;
  final Color tertararyText;
  final Color primaryBackground;
  final Color secondaryBackground;
  final Color tertararyBackground;
  final Color backgroundSheet;
  final Color onPrimaryAccent;
  final Color onTertararyBackground;
  final Color onTerararyFill;
  final Color onSecondaryBackground;
  final Color strokeElements;
  final Color sheetLine;
  final Color attentionRed;
  final Color success;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryAccent,
    Color? primaryText,
    Color? secondaryText,
    Color? tertararyText,
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? tertararyBackground,
    Color? backgroundSheet,
    Color? onPrimaryAccent,
    Color? onTertararyBackground,
    Color? onTerararyFill,
    Color? onSecondaryBackground,
    Color? strokeElements,
    Color? sheetLine,
    Color? attentionRed,
    Color? success,
  }) {
    return AppColorsExtension(
      primaryAccent: primaryAccent ?? this.primaryAccent,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertararyText: tertararyText ?? this.tertararyText,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      tertararyBackground: tertararyBackground ?? this.tertararyBackground,
      backgroundSheet: backgroundSheet ?? this.backgroundSheet,
      onPrimaryAccent: onPrimaryAccent ?? this.onPrimaryAccent,
      onTertararyBackground:
          onTertararyBackground ?? this.onTertararyBackground,
      onTerararyFill: onTerararyFill ?? this.onTerararyFill,
      onSecondaryBackground:
          onSecondaryBackground ?? this.onSecondaryBackground,
      strokeElements: strokeElements ?? this.strokeElements,
      sheetLine: sheetLine ?? this.sheetLine,
      attentionRed: attentionRed ?? this.attentionRed,
      success: success ?? this.success,
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
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertararyText: Color.lerp(tertararyText, other.tertararyText, t)!,
      primaryBackground:
          Color.lerp(primaryBackground, other.primaryBackground, t)!,
      secondaryBackground:
          Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      tertararyBackground:
          Color.lerp(tertararyBackground, other.tertararyBackground, t)!,
      backgroundSheet: Color.lerp(backgroundSheet, other.backgroundSheet, t)!,
      onPrimaryAccent: Color.lerp(onPrimaryAccent, other.onPrimaryAccent, t)!,
      onTertararyBackground:
          Color.lerp(onTertararyBackground, other.onTertararyBackground, t)!,
      onTerararyFill: Color.lerp(onTerararyFill, other.onTerararyFill, t)!,
      onSecondaryBackground:
          Color.lerp(onSecondaryBackground, other.onSecondaryBackground, t)!,
      strokeElements: Color.lerp(strokeElements, other.strokeElements, t)!,
      sheetLine: Color.lerp(sheetLine, other.sheetLine, t)!,
      attentionRed: Color.lerp(attentionRed, other.attentionRed, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}
