import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/templates/converters.dart';

part 'template.g.dart';

@JsonSerializable()
class TemplateColors {
  TemplateColors(
    this.primaryAccent,
    this.primaryText,
    this.secondaryText,
    this.tertararyText,
    this.primaryBackground,
    this.secondaryBackground,
    this.tertararyBackground,
    this.backgroundSheet,
    this.onPrimaryAccent,
    this.onTertararyBackground,
    this.onTerararyFill,
    this.onSecondaryBackground,
    this.strokeElements,
    this.sheetLine,
    this.attentionRed,
    this.success,
  );

  factory TemplateColors.fromJson(Map<String, dynamic> json) =>
      _$TemplateColorsFromJson(json);

  @ColorConverter()
  Color primaryAccent;
  @ColorConverter()
  Color primaryText;
  @ColorConverter()
  Color secondaryText;
  @ColorConverter()
  Color tertararyText;
  @ColorConverter()
  Color primaryBackground;
  @ColorConverter()
  Color secondaryBackground;
  @ColorConverter()
  Color tertararyBackground;
  @ColorConverter()
  Color backgroundSheet;
  @ColorConverter()
  Color onPrimaryAccent;
  @ColorConverter()
  Color onTertararyBackground;
  @ColorConverter()
  Color onTerararyFill;
  @ColorConverter()
  Color onSecondaryBackground;
  @ColorConverter()
  Color strokeElements;
  @ColorConverter()
  Color sheetLine;
  @ColorConverter()
  Color attentionRed;
  @ColorConverter()
  Color success;
}

@JsonSerializable()
class TemplateColorsLightDark {
  TemplateColorsLightDark(this.light, this.dark);

  factory TemplateColorsLightDark.fromJson(Map<String, dynamic> json) =>
      _$TemplateColorsLightDarkFromJson(json);

  TemplateColors light;
  TemplateColors dark;
}

@JsonSerializable()
class TemplateAppBarTheme {
  TemplateAppBarTheme(this.toolbarHeight);

  factory TemplateAppBarTheme.fromJson(Map<String, dynamic> json) =>
      _$TemplateAppBarThemeFromJson(json);

  double toolbarHeight;
}

@JsonSerializable()
class TemplateTextTheme {
  TemplateTextTheme(this.fontSize, this.height, this.fontWeight);

  factory TemplateTextTheme.fromJson(Map<String, dynamic> json) =>
      _$TemplateTextThemeFromJson(json);

  double? fontSize;
  double? height;
  @FontWeightConverter()
  FontWeight? fontWeight;
}

@JsonSerializable()
class TemplateTextThemes {
  TemplateTextThemes(
    this.headline1,
    this.inputFieldText,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.body,
    this.body2,
    this.caption,
    this.caption2,
    this.caption3,
  );

  factory TemplateTextThemes.fromJson(Map<String, dynamic> json) =>
      _$TemplateTextThemesFromJson(json);

  TemplateTextTheme headline1;
  TemplateTextTheme inputFieldText;
  TemplateTextTheme title;
  TemplateTextTheme subtitle;
  TemplateTextTheme subtitle2;
  TemplateTextTheme body;
  TemplateTextTheme body2;
  TemplateTextTheme caption;
  TemplateTextTheme caption2;
  TemplateTextTheme caption3;
}

@JsonSerializable()
class TemplateMenuTheme {
  TemplateMenuTheme(
    this.elevation,
    this.borderRadius,
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
  );

  factory TemplateMenuTheme.fromJson(Map<String, dynamic> json) =>
      _$TemplateMenuThemeFromJson(json);

  double elevation;
  double borderRadius;
  double paddingLeft;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
}

@JsonSerializable()
class TemplateMenuButtonTheme {
  TemplateMenuButtonTheme(
    this.iconSize,
    this.minHeight,
    this.paddingLeft,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
  );

  factory TemplateMenuButtonTheme.fromJson(Map<String, dynamic> json) =>
      _$TemplateMenuButtonThemeFromJson(json);

  double iconSize;
  double minHeight;
  double paddingLeft;
  double paddingTop;
  double paddingRight;
  double paddingBottom;
}

@JsonSerializable()
class MenuAnchor {
  MenuAnchor(
    this.alignmentOffsetY,
  );

  factory MenuAnchor.fromJson(Map<String, dynamic> json) =>
      _$MenuAnchorFromJson(json);

  double alignmentOffsetY;
}

@JsonSerializable()
class Template {
  Template(
    this.colors,
    this.textThemes,
    this.appBar,
    this.menuAnchor,
    this.menu,
    this.menuButton,
  );

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  TemplateColorsLightDark colors;
  TemplateTextThemes textThemes;
  TemplateAppBarTheme appBar;
  MenuAnchor menuAnchor;
  TemplateMenuTheme menu;
  TemplateMenuButtonTheme menuButton;
}
