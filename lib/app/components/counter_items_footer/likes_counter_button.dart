// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.r.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.r.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class LikesCounterButton extends ConsumerWidget {
  const LikesCounterButton({
    required this.eventReference,
    this.color,
    this.padding,
    super.key,
  });

  final EventReference eventReference;
  final Color? color;
  final EdgeInsetsGeometry? padding;

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
        padding: padding,
        alignment: Alignment.center,
        child: TextActionButton(
          icon: Assets.svg.iconVideoLikeOff.icon(
            size: 16.0.s,
            color: color ?? context.theme.appColors.onTertiaryBackground,
          ),
          textColor: color ?? context.theme.appColors.onTertiaryBackground,
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
