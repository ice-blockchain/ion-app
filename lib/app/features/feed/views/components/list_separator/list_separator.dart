import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FeedListSeparator extends StatelessWidget {
  FeedListSeparator({
    super.key,
    double? height,
  }) : height = height ?? 12.0.s;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: context.theme.appColors.primaryBackground,
    );
  }
}
