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
class Template {
  Template(this.colors, this.appBar);

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  TemplateColorsLightDark colors;
  TemplateAppBarTheme appBar;
}
