// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/generated/assets.gen.dart';

class VideoHeader extends StatelessWidget {
  const VideoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.s),
      child: Row(
        children: [
          VideoButton(
            icon: Assets.svg.iconBackArrow.icon(
              color: context.theme.appColors.secondaryBackground,
            ),
            onPressed: context.pop,
          ),
          SizedBox(width: 10.0.s),
          VideoButton(
            icon: Assets.svg.iconCategoriesForyou.icon(
              color: context.theme.appColors.secondaryBackground,
            ),
            onPressed: () {
              // TODO: add impl for categories for you
            },
          ),
          const Spacer(),
          VideoButton(
            icon: Assets.svg.iconFieldSearch.icon(
              color: context.theme.appColors.secondaryBackground,
            ),
            onPressed: () {
              // TODO: add impl for search
            },
          ),
        ],
      ),
    );
  }
}
