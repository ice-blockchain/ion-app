import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class Delimiter extends StatelessWidget {
  const Delimiter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenSideOffset.defaultSmallMargin,
      ),
      height: 10.0.s,
      color: context.theme.appColors.primaryBackground,
    );
  }
}
