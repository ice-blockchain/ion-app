import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_engagement_metric.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_metric_space.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class PostFooter extends HookConsumerWidget {
  const PostFooter({
    required this.postData,
    super.key,
  });
  final PostData? postData;

  static double get horizontalPadding => max(
        ScreenSideOffset.defaultSmallMargin -
            PostEngagementMetric.horizontalHitSlop,
        0,
      );

  static double get iconSize => 16.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCommentActive = useState(false);
    final isReposted = useState(false);
    final isLiked = useState(false);

    final activeColor = context.theme.appColors.primaryAccent;

    void onToggleComment() {
      isCommentActive.value = !isCommentActive.value;
    }

    void onToggleRepost() {
      IceRoutes.shareType.push(context, payload: postData);
      isReposted.value = !isReposted.value;
    }

    void onToggleLike() {
      isLiked.value = !isLiked.value;
    }

    void onShareOptions() {}

    void onIceStroke() {}

    return Padding(
      padding: EdgeInsets.fromLTRB(
        PostFooter.horizontalPadding,
        10.0.s,
        PostFooter.horizontalPadding,
        0,
      ),
      child: Row(
        children: [
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
              isActive: isCommentActive.value,
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
              isActive: isReposted.value,
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
              isActive: isLiked.value,
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
