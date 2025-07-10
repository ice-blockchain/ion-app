// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/throttled_provider.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.r.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.r.dart';
import 'package:ion/app/services/widget_rebuild_tracker/widget_rebuild_tracker.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

final _provider = Provider.family<({int likesCount, bool isLiked}), EventReference>((ref, eventRef) {
  final likesCount = ref.watch(likesCountProvider(eventRef));
  final isLiked = ref.watch(isLikedProvider(eventRef));
  return (likesCount: likesCount, isLiked: isLiked);
}).throttled();

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
    final value = ref.watch(_provider(eventReference)).valueOrNull;
    final likesCount = value?.likesCount ?? 0;
    final isLiked = value?.isLiked ?? false;

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
