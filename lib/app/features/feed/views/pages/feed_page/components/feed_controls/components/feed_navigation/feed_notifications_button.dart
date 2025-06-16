// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications_subscription_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/unread_notifications_count_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedNotificationsButton extends ConsumerWidget {
  const FeedNotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsSubscriptionProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        NavigationButton(
          onPressed: () => NotificationsHistoryRoute().push<void>(context),
          icon: Assets.svgIconHomeNotification.icon(
            color: context.theme.appColors.primaryText,
          ),
        ),
        PositionedDirectional(top: -5.0.s, end: -5.0.s, child: const _UnreadCounter()),
      ],
    );
  }
}

class _UnreadCounter extends ConsumerWidget {
  const _UnreadCounter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider).valueOrNull;

    if (unreadCount == null || unreadCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.s, vertical: 2.5.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.s),
        color: context.theme.appColors.attentionRed,
      ),
      constraints: BoxConstraints(minWidth: 20.0.s),
      child: Text(
        unreadCount.toString(),
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption5.copyWith(
          color: context.theme.appColors.primaryBackground,
        ),
      ),
    );
  }
}
