import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class Decorations {
  static BoxDecoration borderBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.theme.appColors.secondaryBackground,
      border: Border.all(
        color: context.theme.appColors.onTerararyFill,
      ),
      borderRadius: BorderRadius.circular(30.0.s),
    );
  }
}
