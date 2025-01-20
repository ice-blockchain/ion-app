// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/providers/counters/replied_events_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_info_modal/who_can_reply_info_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class RepliesCounterButton extends HookConsumerWidget {
  const RepliesCounterButton({
    required this.eventReference,
    this.color,
    super.key,
  });

  final EventReference eventReference;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesCount = ref.watch(repliesCountProvider(eventReference));
    final isReplied = ref.watch(isRepliedProvider(eventReference));
    final canReply = ref.watch(canReplyProvider(eventReference)).value ?? false;
    final isLoading = useRef(false);

    return GestureDetector(
      onTap: isLoading.value
          ? null
          : () async {
              try {
                isLoading.value = true;
                await _onTap(context, ref);
              } finally {
                isLoading.value = false;
              }
            },
      child: TextActionButton(
        icon: Assets.svg.iconBlockComment.icon(
          size: 16.0.s,
          color: color ?? context.theme.appColors.onTertararyBackground,
        ),
        textColor: color ?? context.theme.appColors.onTertararyBackground,
        activeIcon: Assets.svg.iconBlockCommenton.icon(
          size: 16.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
        activeTextColor: context.theme.appColors.primaryAccent,
        disabledIcon: Assets.svg.iconBlockComment.icon(
          size: 16.0.s,
          color: context.theme.appColors.tertararyText,
        ),
        disabledTextColor: context.theme.appColors.tertararyText,
        value: formatDoubleCompact(repliesCount),
        state: switch ((canReply, isReplied)) {
          (false, _) => TextActionButtonState.disabled,
          (true, true) => TextActionButtonState.active,
          (true, false) => TextActionButtonState.idle,
        },
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    ref.read(canReplyProvider(eventReference).notifier).refreshIfNeeded(eventReference);
    final canReply = await ref.read(canReplyProvider(eventReference).future);
    if (!context.mounted) return;

    if (canReply) {
      await CreatePostRoute(parentEvent: eventReference.toString()).push<void>(context);
      await HapticFeedback.lightImpact();
    } else {
      await showSimpleBottomSheet<void>(
        context: context,
        child: WhoCanReplyInfoModal(
          eventReference: eventReference,
        ),
      );
    }
  }
}
