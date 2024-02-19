import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FeedListSeparator extends StatelessWidget {
  const FeedListSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.0.s,
      color: context.theme.appColors.primaryBackground,
    );
  }
}
