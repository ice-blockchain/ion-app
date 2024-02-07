import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/templates/converters.dart';

part 'template.freezed.dart';

part 'template.g.dart';

@freezed
class TemplateColors with _$TemplateColors {
  @JsonSerializable(converters: <JsonConverter<dynamic, String>>[ColorConverter()])
  const factory TemplateColors(
      Color primaryAccent,
      Color primaryText,
      Color secondaryText,
      Color tertararyText,
      Color primaryBackground,
      Color secondaryBackground,
      Color tertararyBackground,
      Color backgroundSheet,
      Color onPrimaryAccent,
      Color onTertararyBackground,
      Color onTerararyFill,
      Color onSecondaryBackground,
      Color strokeElements,
      Color sheetLine,
      Color attentionRed,
      Color success,
      ) = _TemplateColors;

  factory TemplateColors.fromJson(Map<String, dynamic> json) => _$TemplateColorsFromJson(json);
}

@freezed
class TemplateColorsLightDark with _$TemplateColorsLightDark {
  const factory TemplateColorsLightDark(
      TemplateColors light,
      TemplateColors dark,
      ) = _TemplateColorsLightDark;

  factory TemplateColorsLightDark.fromJson(Map<String, dynamic> json) => _$TemplateColorsLightDarkFromJson(json);
}

@freezed
class TemplateAppBarTheme with _$TemplateAppBarTheme {
  const factory TemplateAppBarTheme(double toolbarHeight) = _TemplateAppBarTheme;

  factory TemplateAppBarTheme.fromJson(Map<String, dynamic> json) => _$TemplateAppBarThemeFromJson(json);
}

@freezed
class TemplateTextTheme with _$TemplateTextTheme {
  const factory TemplateTextTheme(
      double? fontSize,
      double? height,
      @FontWeightConverter() FontWeight? fontWeight,
      ) = _TemplateTextTheme;

  factory TemplateTextTheme.fromJson(Map<String, dynamic> json) => _$TemplateTextThemeFromJson(json);
}

@freezed
class TemplateTextThemes with _$TemplateTextThemes {
  const factory TemplateTextThemes(
      TemplateTextTheme headline1,
      TemplateTextTheme inputFieldText,
      TemplateTextTheme title,
      TemplateTextTheme subtitle,
      TemplateTextTheme subtitle2,
      TemplateTextTheme body,
      TemplateTextTheme body2,
      TemplateTextTheme caption,
      TemplateTextTheme caption2,
      TemplateTextTheme caption3,
      ) = _TemplateTextThemes;

  factory TemplateTextThemes.fromJson(Map<String, dynamic> json) => _$TemplateTextThemesFromJson(json);
}

@freezed
class TemplateMenuTheme with _$TemplateMenuTheme {
  const factory TemplateMenuTheme(
      double elevation,
      double borderRadius,
      double paddingLeft,
      double paddingTop,
      double paddingRight,
      double paddingBottom,
      ) = _TemplateMenuTheme;

  factory TemplateMenuTheme.fromJson(Map<String, dynamic> json) => _$TemplateMenuThemeFromJson(json);
}

@freezed
class TemplateMenuButtonTheme with _$TemplateMenuButtonTheme {
  const factory TemplateMenuButtonTheme(
      double iconSize,
      double minHeight,
      double paddingLeft,
      double paddingTop,
      double paddingRight,
      double paddingBottom,
      ) = _TemplateMenuButtonTheme;

  factory TemplateMenuButtonTheme.fromJson(Map<String, dynamic> json) => _$TemplateMenuButtonThemeFromJson(json);
}

@freezed
class MenuAnchor with _$MenuAnchor {
  const factory MenuAnchor(
      double alignmentOffsetY,
      ) = _MenuAnchor;

  factory MenuAnchor.fromJson(Map<String, dynamic> json) => _$MenuAnchorFromJson(json);
}

@freezed
class TemplateIconButtonTheme with _$TemplateIconButtonTheme {
  const factory TemplateIconButtonTheme({
    required double width,
    required double height,
    required String backgroundColor,
  }) = _TemplateIconButtonTheme;

  factory TemplateIconButtonTheme.fromJson(Map<String, dynamic> json) => _$TemplateIconButtonThemeFromJson(json);
}

@freezed
class TemplateIconTheme with _$TemplateIconTheme {
  const factory TemplateIconTheme({
    required double width,
    required double height,
  }) = _TemplateIconThem;

  factory TemplateIconTheme.fromJson(Map<String, dynamic> json) => _$TemplateIconThemeFromJson(json);
}


@freezed
class TemplateTheme with _$TemplateTheme {
  const factory TemplateTheme(
      TemplateColorsLightDark colors,
      TemplateTextThemes textThemes,
      TemplateAppBarTheme appBar,
      MenuAnchor menuAnchor,
      TemplateMenuTheme menu,
      TemplateMenuButtonTheme menuButton,
      TemplateIconButtonTheme iconButton,
      TemplateIconTheme icon,
      ) = _TemplateTheme;

  factory TemplateTheme.fromJson(Map<String, dynamic> json) => _$TemplateThemeFromJson(json);
}

@freezed
class Template with _$Template {
  const factory Template(
      TemplateTheme theme,
      TemplateConfig config,
      ) = _Template;

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);
}


@freezed
class TemplateConfig with _$TemplateConfig {
  const factory TemplateConfig({
    Map<String, TemplateConfigPage>? pages,
  }) = _TemplateConfig;

  factory TemplateConfig.fromJson(Map<String, dynamic> json) => _$TemplateConfigFromJson(json);
}

abstract class TemplateConfigElement {

  bool? get hidden;
}

@freezed
class TemplateConfigPage with _$TemplateConfigPage implements TemplateConfigElement {
  const factory TemplateConfigPage({
    bool? hidden,
    Map<String, TemplateConfigControl>? controls,
  }) = _TemplateConfigPage;

  factory TemplateConfigPage.fromJson(Map<String, dynamic> json) => _$TemplateConfigPageFromJson(json);
}

@freezed
class TemplateConfigControl with _$TemplateConfigControl implements TemplateConfigElement {
  const factory TemplateConfigControl({
    bool? hidden,
    int? variant,
  }) = _TemplateConfigControl;

  factory TemplateConfigControl.fromJson(Map<String, dynamic> json) => _$TemplateConfigControlFromJson(json);
}
