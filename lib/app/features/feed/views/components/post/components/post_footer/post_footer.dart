import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_engagement_metric.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_metric_space.dart';
import 'package:ice/generated/assets.gen.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({
    required this.content,
    required this.isCommentActive,
    required this.isReposted,
    required this.isLiked,
    required this.onToggleComment,
    required this.onToggleRepost,
    required this.onToggleLike,
    required this.onShareOptions,
    required this.onIceStroke,
    super.key,
  });

  final String content;
  final bool isCommentActive;
  final bool isReposted;
  final bool isLiked;
  final VoidCallback onToggleComment;
  final VoidCallback onToggleRepost;
  final VoidCallback onToggleLike;
  final VoidCallback onShareOptions;
  final VoidCallback onIceStroke;

  static double get horizontalPadding => max(
        ScreenSideOffset.defaultSmallMargin -
            PostEngagementMetric.horizontalHitSlop,
        0,
      );

  static double get iconSize => 16.0.s;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.theme.appColors.primaryAccent;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        PostFooter.horizontalPadding,
        10.0.s,
        PostFooter.horizontalPadding,
        0,
      ),
      child: Row(
        children: <Widget>[
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: onToggleComment,
              icon: Assets.images.icons.iconBlockComment.icon(
                size: PostFooter.iconSize,
              ),
              activeIcon: Assets.images.icons.iconBlockCommentActive.icon(
                size: PostFooter.iconSize,
              ),
              value: '121k',
              isActive: isCommentActive,
              activeColor: activeColor,
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: onToggleRepost,
              icon: Assets.images.icons.iconBlockRepost.icon(
                size: PostFooter.iconSize,
              ),
              activeIcon: Assets.images.icons.iconBlockRepost.icon(
                size: PostFooter.iconSize,
                color: activeColor,
              ),
              value: '442k',
              isActive: isReposted,
              activeColor: activeColor,
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: onToggleLike,
              icon: Assets.images.icons.iconVideoLikeOff.icon(
                size: PostFooter.iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              activeIcon: Assets.images.icons.iconVideoLikeOn.icon(
                size: PostFooter.iconSize,
                color: context.theme.appColors.attentionRed,
              ),
              value: '121k',
              isActive: isLiked,
              activeColor: context.theme.appColors.attentionRed,
            ),
          ),
          PostMetricSpace(
            child: PostEngagementMetric(
              onPressed: onIceStroke,
              icon: Assets.images.icons.iconButtonIceStroke.icon(
                size: PostFooter.iconSize,
                color: context.theme.appColors.onTertararyBackground,
              ),
              value: '7',
              activeColor: activeColor,
            ),
          ),
          PostEngagementMetric(
            onPressed: onShareOptions,
            icon: Assets.images.icons.iconBlockShare.icon(
              size: PostFooter.iconSize,
            ),
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}
