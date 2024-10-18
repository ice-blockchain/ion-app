// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';

class SignUpFixedFooter extends StatelessWidget {
  const SignUpFixedFooter({
    required this.height,
    required this.child,
    super.key,
  });

  final double height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HorizontalSeparator(),
          ScreenBottomOffset(
            margin: 0,
            child: Container(
              height: height,
              color: context.theme.appColors.secondaryBackground,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 16.0.s,
                left: ScreenSideOffset.defaultLargeMargin,
                right: ScreenSideOffset.defaultLargeMargin,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
