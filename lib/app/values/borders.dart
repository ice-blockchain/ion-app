import 'package:flutter/material.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/values/constants.dart';

final Radius kDefaultRadius = Radius.circular(kDefaultBorderRadiusValue);

final ShapeBorder kBottomSheetBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: kDefaultRadius),
);

final BorderRadius defaultBorderRadius =
    BorderRadius.circular(kDefaultBorderRadiusValue);
final BoxDecoration defaultBoxDecoration =
    BoxDecoration(borderRadius: defaultBorderRadius);
const BorderSide defaultBorderSide = BorderSide(color: Colors.transparent);

final BorderRadius kFieldBorderRadius =
    BorderRadius.all(Radius.circular(kDefaultBorderRadiusValue));

class InputFieldBorder extends OutlineInputBorder {
  InputFieldBorder({
    BorderSide? borderSide,
  }) : super(
          borderSide: borderSide ?? defaultBorderSide,
          borderRadius: kFieldBorderRadius,
        );

  factory InputFieldBorder.focused() => InputFieldBorder(
        borderSide: BorderSide(color: appTemplate.theme.colors.light.primaryAccent),
      );

  factory InputFieldBorder.error() => InputFieldBorder(
        borderSide: BorderSide(color: appTemplate.theme.colors.light.attentionRed),
      );
}
