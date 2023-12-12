import 'package:flutter/material.dart';
import 'package:ice/app/values/constants.dart';

final Radius kDefaultRadius = Radius.circular(kDefaultBorderRadiusValue);

final ShapeBorder kBottomSheetBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: kDefaultRadius),
);

final BorderRadius defaultBorderRadius =
    BorderRadius.circular(kDefaultBorderRadiusValue);
final BoxDecoration defaultBoxDecoration =
    BoxDecoration(borderRadius: defaultBorderRadius);

final BorderRadius kFieldBorderRadius =
    BorderRadius.all(Radius.circular(kDefaultBorderRadiusValue));

class InputFieldBorder extends OutlineInputBorder {
  InputFieldBorder({
    super.borderSide = const BorderSide(color: Colors.transparent),
  }) : super(borderRadius: kFieldBorderRadius);

  factory InputFieldBorder.focused() => InputFieldBorder(
        // TODO: get this color from context
        borderSide: const BorderSide(color: Color.fromARGB(255, 206, 206, 206)),
      );

  factory InputFieldBorder.error() =>
      // TODO: get this color from context
      InputFieldBorder(borderSide: const BorderSide(color: Colors.red));
}
