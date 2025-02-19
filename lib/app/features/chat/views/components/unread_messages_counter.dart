import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/providers/e2ee_messages_subscriber.c.dart';
import 'package:ion/app/features/chat/providers/unread_message_count_provider.c.dart';

class UnreadMessagesCounter extends ConsumerWidget {
  const UnreadMessagesCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(e2eeMessagesSubscriberProvider);
    final unreadMessagesCount = ref.watch(getAllUnreadMessagesCountProvider).valueOrNull ?? 0;

    if (unreadMessagesCount == 0) {
      return const SizedBox();
    }
    return Positioned(
      top: 10.0.s,
      right: 22.0.s,
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
