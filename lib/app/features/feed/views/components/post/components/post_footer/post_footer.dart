import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_engagement_metric.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_metric_space.dart';
import 'package:ice/generated/assets.gen.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({super.key});

  static double get horizontalPadding => max(
        ScreenSideOffset.defaultSmallMargin -
            PostEngagementMetric.horizontalHitSlop,
        0,
      );

  static double get iconSize => UiSize.large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        UiSize.smallMedium,
        horizontalPadding,
        0,
      ),
      child: Row(
        children: <Widget>[
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconBlockComment.icon(
                size: iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              value: '121k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconBlockRepost.icon(
                size: iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              value: '442k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconVideoLikeOff.icon(
                size: iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              value: '121k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconButtonIceStroke.icon(
                size: iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              value: '7',
            ),
          ),
          PostEngagementMetric(
            onPressed: () {},
            icon: Assets.images.icons.iconBlockShare.icon(
              size: iconSize,
              color: context.theme.appColors.onTertararyBackground,
            ),
          ),
        ],
      ),
    );
  }
}
