// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/optimistic_ui/providers/post_like_provider.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class LikesCounterButton extends ConsumerWidget {
  const LikesCounterButton({
    required this.eventReference,
    this.color,
    super.key,
  });

  final EventReference eventReference;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(likesCountProvider(eventReference));
    final isLiked = ref.watch(isLikedProvider(eventReference));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(toggleLikeNotifierProvider.notifier).toggle(eventReference);
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 50.0.s),
        alignment: Alignment.center,
        child: TextActionButton(
          icon: Assets.svg.iconVideoLikeOff.icon(
            size: 16.0.s,
            color: color ?? context.theme.appColors.onTertararyBackground,
          ),
          textColor: color ?? context.theme.appColors.onTertararyBackground,
          activeIcon: Assets.svg.iconVideoLikeOn.icon(
            size: 16.0.s,
            color: context.theme.appColors.attentionRed,
          ),
          activeTextColor: context.theme.appColors.attentionRed,
          value: formatDoubleCompact(likesCount),
          state: isLiked ? TextActionButtonState.active : TextActionButtonState.idle,
        ),
      ),
    );
  }
}
