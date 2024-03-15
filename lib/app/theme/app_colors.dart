import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primaryAccent,
    required this.primaryText,
    required this.secondaryText,
    required this.tertararyText,
    required this.sharkText,
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
    required this.orangePeel,
    required this.purple,
    required this.raspberry,
    required this.darkBlue,
  });

  factory AppColorsExtension.fromTemplate(TemplateColors templateColors) {
    return AppColorsExtension(
      primaryAccent: templateColors.primaryAccent,
      primaryText: templateColors.primaryText,
      secondaryText: templateColors.secondaryText,
      tertararyText: templateColors.tertararyText,
      sharkText: templateColors.sharkText,
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
      orangePeel: templateColors.orangePeel,
      purple: templateColors.purple,
      raspberry: templateColors.raspberry,
      darkBlue: templateColors.darkBlue,
    );
  }

  final Color primaryAccent;
  final Color primaryText;
  final Color secondaryText;
  final Color tertararyText;
  final Color sharkText;
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
  final Color orangePeel;
  final Color purple;
  final Color raspberry;
  final Color darkBlue;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primaryAccent,
    Color? primaryText,
    Color? secondaryText,
    Color? tertararyText,
    Color? sharkText,
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
    Color? orangePeel,
    Color? purple,
    Color? raspberry,
    Color? darkBlue,
  }) {
    return AppColorsExtension(
      primaryAccent: primaryAccent ?? this.primaryAccent,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertararyText: tertararyText ?? this.tertararyText,
      sharkText: sharkText ?? this.sharkText,
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
      orangePeel: orangePeel ?? this.orangePeel,
      purple: purple ?? this.purple,
      raspberry: raspberry ?? this.raspberry,
      darkBlue: darkBlue ?? this.darkBlue,
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
      sharkText: Color.lerp(sharkText, other.sharkText, t)!,
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
      orangePeel: Color.lerp(orangePeel, other.orangePeel, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      raspberry: Color.lerp(raspberry, other.raspberry, t)!,
      darkBlue: Color.lerp(darkBlue, other.darkBlue, t)!,
    );
  }
}
