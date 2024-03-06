import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/post/components/post_footer/post_engagement_metric.dart';
import 'package:ice/app/features/feed/components/post/components/post_footer/post_metric_space.dart';
import 'package:ice/generated/assets.gen.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({super.key});

  static double get horizontalPadding => max(
        ScreenSideOffset.defaultSmallMargin -
            PostEngagementMetric.horizontalHitSlop,
        0,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        10.0.s,
        horizontalPadding,
        0,
      ),
      child: Row(
        children: <Widget>[
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconBlockComment.icon(size: 16.0.s),
              value: '121k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconBlockRepost.icon(size: 16.0.s),
              value: '442k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconVideoLikeOff.icon(size: 16.0.s),
              value: '121k',
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: () {},
              icon: Assets.images.icons.iconButtonIceStroke.icon(size: 16.0.s),
              value: '7',
            ),
          ),
          PostEngagementMetric(
            onPressed: () {},
            icon: Assets.images.icons.iconBlockShare.icon(size: 16.0.s),
          ),
        ],
      ),
    );
  }
}
