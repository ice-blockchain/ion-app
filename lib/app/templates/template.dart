import 'package:freezed_annotation/freezed_annotation.dart';

part 'template.g.dart';

@JsonSerializable()
class TemplateColors {
  TemplateColors(this.primary, this.background);

  factory TemplateColors.fromJson(Map<String, dynamic> json) =>
      _$TemplateColorsFromJson(json);

  int primary;
  int background;
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
  TemplateTextTheme(this.fontSize, this.letterSpacing);

  factory TemplateTextTheme.fromJson(Map<String, dynamic> json) =>
      _$TemplateTextThemeFromJson(json);

  double fontSize;
  double letterSpacing;
}

@JsonSerializable()
class TemplateTextThemes {
  TemplateTextThemes(this.h1, this.body1);

  factory TemplateTextThemes.fromJson(Map<String, dynamic> json) =>
      _$TemplateTextThemesFromJson(json);

  TemplateTextTheme h1;
  TemplateTextTheme body1;
}

@JsonSerializable()
class Template {
  Template(this.colors, this.textThemes, this.appBar);

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  TemplateColorsLightDark colors;
  TemplateTextThemes textThemes;
  TemplateAppBarTheme appBar;
}
