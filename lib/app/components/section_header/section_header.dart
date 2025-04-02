// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/section_header/section_header_button.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader({
    super.key,
    String? title,
    this.onPress,
    this.leadingIcon,
    double? leadingIconOffset,
  })  : leadingIconOffset = leadingIconOffset ?? 4.0.s,
        title = title ?? '';

  final String title;
  final double leadingIconOffset;
  final VoidCallback? onPress;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      only: ScreenOffsetSide.left,
      child: SizedBox(
        height: 46.0.s,
        child: Row(
          children: [
            if (leadingIcon != null)
              Padding(
                padding: EdgeInsetsDirectional.only(end: leadingIconOffset),
                child: leadingIcon,
              ),
            Expanded(
              child: Text(
                title,
                style: context.theme.appTextThemes.subtitle
                    .copyWith(color: context.theme.appColors.primaryText),
              ),
            ),
            if (onPress != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  end: ScreenSideOffset.defaultSmallMargin - SectionHeaderButton.hitSlop,
                ),
                child: SectionHeaderButton(onPress!),
              ),
          ],
        ),
      ),
    );
  }
}
