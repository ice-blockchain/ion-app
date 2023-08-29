import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'colors.g.dart';

@JsonSerializable()
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.background,
  });

  factory AppColorsExtension.fromJson(Map<String, dynamic> json) =>
      _$AppColorsExtensionFromJson(json);

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color primary;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
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

  static Color _colorFromJson(int value) => Color(value);

  static int _colorToJson(Color value) => value.value;
}

AppColorsExtension lightColors = AppColorsExtension.fromJson(
  <String, dynamic>{'primary': 0xff6200ee, 'background': 0xffffffee},
);

AppColorsExtension darkColors = AppColorsExtension.fromJson(
  <String, dynamic>{'primary': 0xFFEBDDF9, 'background': 0xFFFF6F00},
);

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? lightColors;
}
