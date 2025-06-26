// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/unread_message_count_provider.r.dart';

class UnreadMessagesCounter extends ConsumerWidget {
  const UnreadMessagesCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadMessagesCount = ref.watch(getAllUnreadMessagesCountProvider).valueOrNull ?? 0;

    if (unreadMessagesCount == 0) {
      return const SizedBox();
    }
    return PositionedDirectional(
      top: 10.0.s,
      end: 22.0.s,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0.s, vertical: 2.0.s),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.s),
          color: context.theme.appColors.attentionRed,
        ),
        constraints: BoxConstraints(
          minWidth: 16.0.s,
        ),
        child: Text(
          '$unreadMessagesCount',
          textAlign: TextAlign.center,
          style: context.theme.appTextThemes.notificationCaption.copyWith(
            color: context.theme.appColors.primaryBackground,
          ),
        ),
      ),
    );
  }
}
