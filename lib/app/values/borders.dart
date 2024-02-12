import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';

final Radius kDefaultRadius = Radius.circular(16.0.s);

final ShapeBorder kBottomSheetBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: kDefaultRadius),
);

final BorderRadius defaultBorderRadius = BorderRadius.circular(16.0.s);
final BoxDecoration defaultBoxDecoration =
    BoxDecoration(borderRadius: defaultBorderRadius);
const BorderSide defaultBorderSide = BorderSide(color: Colors.transparent);

final BorderRadius kFieldBorderRadius =
    BorderRadius.all(Radius.circular(16.0.s));

class InputFieldBorder extends OutlineInputBorder {
  InputFieldBorder({
    BorderSide? borderSide,
  }) : super(
          borderSide: borderSide ?? defaultBorderSide,
          borderRadius: kFieldBorderRadius,
        );

  factory InputFieldBorder.focused() => InputFieldBorder(
        borderSide: BorderSide(color: appTemplate.colors.light.primaryAccent),
      );

  factory InputFieldBorder.error() => InputFieldBorder(
        borderSide: BorderSide(color: appTemplate.colors.light.attentionRed),
      );
}
