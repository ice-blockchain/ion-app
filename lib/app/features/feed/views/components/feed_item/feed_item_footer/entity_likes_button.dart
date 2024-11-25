// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.dart';
import 'package:ion/app/features/feed/providers/counters/likes_notifier.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_action_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class EntityLikesButton extends ConsumerWidget {
  const EntityLikesButton({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(likesCountProvider(eventReference));
    final isLiked = ref.watch(isLikedProvider(eventReference));

    ref.displayErrors(likesNotifierProvider(eventReference));

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(likesNotifierProvider(eventReference).notifier).toggle();
      },
      child: FeedItemActionButton(
        icon: Assets.svg.iconVideoLikeOff.icon(
          size: 16.0.s,
          color: context.theme.appColors.onTertararyBackground,
        ),
        activeIcon: Assets.svg.iconVideoLikeOn.icon(
          size: 16.0.s,
          color: context.theme.appColors.attentionRed,
        ),
        value: likesCount != null ? formatDoubleCompact(likesCount) : '',
        activeColor: context.theme.appColors.attentionRed,
        isActive: isLiked,
      ),
    );
  }
}
