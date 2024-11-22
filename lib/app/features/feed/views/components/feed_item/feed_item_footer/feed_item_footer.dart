// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/num.dart';
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
    final isReposted = useState(false);
    final isLiked = useState(false);

    final activeColor = context.theme.appColors.primaryAccent;

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
          Flexible(child: CommentsButton(eventReference: eventReference)),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onToggleRepost,
                  child: repostsActionIcon,
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: GestureDetector(
              onTap: onToggleLike,
              child: likesActionIcon,
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onShareOptions,
                  child: shareActionIcon,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsButton extends ConsumerWidget {
  const CommentsButton({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countEntity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity<int>>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.replies,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        CreatePostRoute(parentEvent: eventReference.toString()).push<void>(context);
      },
      child: FeedItemActionButton(
        icon: Assets.svg.iconBlockComment.icon(
          size: 14.0.s,
        ),
        activeIcon: Assets.svg.iconBlockCommenton.icon(
          size: 14.0.s,
        ),
        value: countEntity != null
            ? formatDoubleCompact(countEntity.data.content)
            : formatDoubleCompact(45311),
        activeColor: context.theme.appColors.primaryAccent,
      ),
    );
  }
}
