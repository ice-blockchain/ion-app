import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_action_button.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

typedef ActionIconBuilder = Widget Function(
  BuildContext context,
  Widget child,
  VoidCallback onPressed,
);

class PostFooter extends HookConsumerWidget {
  PostFooter({
    required this.postData,
    this.actionBuilder,
    double? bottomPadding,
    super.key,
  }) : bottomPadding = bottomPadding ?? 16.0.s;

  final PostData postData;
  final ActionIconBuilder? actionBuilder;
  final double bottomPadding;

  static double get iconSize => 16.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCommentActive = useState(false);
    final isReposted = useState(false);
    final isLiked = useState(false);

    final activeColor = context.theme.appColors.primaryAccent;

    void onToggleComment() {
      HapticFeedback.lightImpact();
      PostReplyRoute(postId: postData.id).push<void>(context);
      isCommentActive.value = !isCommentActive.value;
    }

    void onToggleRepost() {
      HapticFeedback.lightImpact();
      RepostOptionsModalRoute(postId: postData.id).push<void>(context);
      isReposted.value = !isReposted.value;
    }

    void onToggleLike() {
      HapticFeedback.lightImpact();
      isLiked.value = !isLiked.value;
    }

    void onShareOptions() {
      HapticFeedback.lightImpact();
      SharePostModalRoute(postId: postData.id).push<void>(context);
    }

    void onIceStroke() => HapticFeedback.lightImpact();

    final commentsActionIcon = PostActionButton(
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

    final repostsActionIcon = PostActionButton(
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

    final likesActionIcon = PostActionButton(
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

    final iceActionIcon = PostActionButton(
      icon: Assets.images.icons.iconButtonIceStroke.icon(
        size: PostFooter.iconSize,
        color: context.theme.appColors.onTertararyBackground,
      ),
      value: '7',
      activeColor: activeColor,
    );

    final shareActionIcon = PostActionButton(
      icon: Assets.images.icons.iconBlockShare.icon(
        size: PostFooter.iconSize,
      ),
      activeColor: activeColor,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionIcon(
            onPressed: onToggleComment,
            actionBuilder: actionBuilder,
            child: commentsActionIcon,
          ),
          _ActionIcon(
            onPressed: onToggleRepost,
            actionBuilder: actionBuilder,
            child: repostsActionIcon,
          ),
          _ActionIcon(
            onPressed: onToggleLike,
            actionBuilder: actionBuilder,
            child: likesActionIcon,
          ),
          _ActionIcon(
            onPressed: onIceStroke,
            actionBuilder: actionBuilder,
            child: iceActionIcon,
          ),
          _ActionIcon(
            onPressed: onShareOptions,
            actionBuilder: actionBuilder,
            child: shareActionIcon,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.child,
    required this.onPressed,
    this.actionBuilder,
  });

  final Widget child;
  final VoidCallback onPressed;
  final ActionIconBuilder? actionBuilder;

  @override
  Widget build(BuildContext context) {
    return actionBuilder == null
        ? InkResponse(
            onTap: onPressed,
            splashFactory: InkRipple.splashFactory,
            child: child,
          )
        : actionBuilder!(
            context,
            child,
            onPressed,
          );
  }
}
