import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FeedListSeparator extends StatelessWidget {
  FeedListSeparator({
    super.key,
    double? height,
  }) : height = height ?? UiSize.medium;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: context.theme.appColors.primaryBackground,
    );
  }
}
