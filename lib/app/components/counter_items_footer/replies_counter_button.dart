// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/counters/replied_events_provider.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class RepliesCounterButton extends ConsumerWidget {
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

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        CreatePostRoute(parentEvent: eventReference.toString()).push<void>(context);
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
        value: repliesCount != null ? formatDoubleCompact(repliesCount) : '',
        isActive: isReplied,
      ),
    );
  }
}