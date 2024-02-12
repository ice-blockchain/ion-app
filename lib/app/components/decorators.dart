import 'package:flutter/material.dart';
import 'package:ice/app/values/constants.dart';

class RoundedContainer extends Container {
  RoundedContainer({
    super.key,
    super.child,
    double? radius,
    Color? color,
    BoxBorder? border,
    EdgeInsets super.padding = EdgeInsets.zero,
    EdgeInsets super.margin = EdgeInsets.zero,
    super.width,
    super.height,
  }) : super(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? kDefaultBorderRadiusValue),
            ),
            color: color,
          ),
        );
}
