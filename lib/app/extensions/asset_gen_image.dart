import 'package:flutter/widgets.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/generated/assets.gen.dart';

extension IconExtension on AssetGenImage {
  Widget icon({Color? color, double? size}) {
    final iconSize = size ?? UiSize.large;
    return Image.asset(
      path,
      width: iconSize,
      height: iconSize,
      excludeFromSemantics: true,
      fit: BoxFit.contain,
      color: color,
    );
  }
}
