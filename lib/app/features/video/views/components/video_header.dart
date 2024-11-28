// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class VideoHeader extends StatelessWidget {
  const VideoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.s),
      child: GestureDetector(
        onTap: context.pop,
        child: Container(
          height: 36.0.s,
          width: 36.0.s,
          decoration: BoxDecoration(
            color: context.theme.appColors.primaryText.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Assets.svg.iconBackArrow.icon(
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
        ),
      ),
    );
  }
}
