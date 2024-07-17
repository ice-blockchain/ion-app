import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_engagement_metric.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class PostFooter extends HookConsumerWidget {
  const PostFooter({
    required this.postData,
    this.actionBuilder,
    super.key,
  });

  final PostData postData;
  final TransitionBuilder? actionBuilder;

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
      ShareTypeRoute($extra: postData).push<void>(context);
      isReposted.value = !isReposted.value;
    }

    void onToggleLike() {
      isLiked.value = !isLiked.value;
    }

    void onShareOptions() {
      ShareOptionsRoute().push<void>(context);
    }

    void onIceStroke() {}

    final commentsActionIcon = PostEngagementMetric(
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
    );

    final repostsActionIcon = PostEngagementMetric(
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
    );

    final likesActionIcon = PostEngagementMetric(
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
    );

    final iceActionIcon = PostEngagementMetric(
      onPressed: onIceStroke,
      icon: Assets.images.icons.iconButtonIceStroke.icon(
        size: PostFooter.iconSize,
        color: context.theme.appColors.onTertararyBackground,
      ),
      value: '7',
      activeColor: activeColor,
    );

    final shareActionIcon = PostEngagementMetric(
      onPressed: onShareOptions,
      icon: Assets.images.icons.iconBlockShare.icon(
        size: PostFooter.iconSize,
      ),
      activeColor: activeColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionIcon(
          actionBuilder: actionBuilder,
          child: commentsActionIcon,
        ),
        _ActionIcon(
          actionBuilder: actionBuilder,
          child: repostsActionIcon,
        ),
        _ActionIcon(
          actionBuilder: actionBuilder,
          child: likesActionIcon,
        ),
        _ActionIcon(
          actionBuilder: actionBuilder,
          child: iceActionIcon,
        ),
        _ActionIcon(
          actionBuilder: actionBuilder,
          child: shareActionIcon,
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.child,
    this.actionBuilder,
  });

  final Widget child;
  final TransitionBuilder? actionBuilder;

  @override
  Widget build(BuildContext context) {
    return actionBuilder == null
        ? child
        : actionBuilder!(
            context,
            child,
          );
  }
}
