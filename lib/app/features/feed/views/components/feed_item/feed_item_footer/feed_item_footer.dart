// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedItemFooter extends HookConsumerWidget {
  FeedItemFooter({
    required this.eventReference,
    required this.kind,
    double? bottomPadding,
    double? topPadding,
    super.key,
  })  : bottomPadding = bottomPadding ?? 16.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
  final int kind;
  final double bottomPadding;
  final double topPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCommentActive = useState(false);
    final isReposted = useState(false);
    final isLiked = useState(false);

    final activeColor = context.theme.appColors.primaryAccent;

    void onToggleComment() {
      HapticFeedback.lightImpact();
      CreatePostRoute(parentEvent: eventReference.toString()).push<void>(context);
      isCommentActive.value = !isCommentActive.value;
    }

    void onToggleRepost() {
      HapticFeedback.lightImpact();
      RepostOptionsModalRoute(eventReference: eventReference.toString(), kind: kind)
          .push<void>(context);
      isReposted.value = !isReposted.value;
    }

    void onToggleLike() {
      HapticFeedback.lightImpact();
      isLiked.value = !isLiked.value;
    }

    void onShareOptions() {
      HapticFeedback.lightImpact();
      SharePostModalRoute(postId: eventReference.eventId).push<void>(context);
    }

    void onIceStroke() => HapticFeedback.lightImpact();

    final commentsActionIcon = FeedItemActionButton(
      icon: Assets.svg.iconBlockComment.icon(
        size: 14.0.s,
      ),
      activeIcon: Assets.svg.iconBlockCommenton.icon(
        size: 14.0.s,
      ),
      value: '121k',
      isActive: isCommentActive.value,
      activeColor: activeColor,
    );

    final repostsActionIcon = FeedItemActionButton(
      icon: Assets.svg.iconBlockRepost.icon(
        size: 14.0.s,
      ),
      activeIcon: Assets.svg.iconBlockRepost.icon(
        size: 14.0.s,
        color: activeColor,
      ),
      value: '442k',
      isActive: isReposted.value,
      activeColor: activeColor,
    );

    final likesActionIcon = FeedItemActionButton(
      icon: Assets.svg.iconVideoLikeOff.icon(
        size: 18.0.s,
        color: context.theme.appColors.onTertararyBackground,
      ),
      activeIcon: Assets.svg.iconVideoLikeOn.icon(
        size: 18.0.s,
        color: context.theme.appColors.attentionRed,
      ),
      value: '121k',
      isActive: isLiked.value,
      activeColor: context.theme.appColors.attentionRed,
    );

    final iceActionIcon = FeedItemActionButton(
      icon: Assets.svg.iconButtonIceStroke.icon(
        size: 16.0.s,
        color: context.theme.appColors.onTertararyBackground,
      ),
      value: '7',
      activeColor: activeColor,
    );

    final shareActionIcon = FeedItemActionButton(
      icon: Assets.svg.iconBlockShare.icon(
        size: 14.0.s,
      ),
      activeColor: activeColor,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onToggleComment,
            child: commentsActionIcon,
          ),
          GestureDetector(
            onTap: onToggleRepost,
            child: repostsActionIcon,
          ),
          GestureDetector(
            onTap: onToggleLike,
            child: likesActionIcon,
          ),
          GestureDetector(
            onTap: onIceStroke,
            child: iceActionIcon,
          ),
          GestureDetector(
            onTap: onShareOptions,
            child: shareActionIcon,
          ),
        ],
      ),
    );
  }
}
