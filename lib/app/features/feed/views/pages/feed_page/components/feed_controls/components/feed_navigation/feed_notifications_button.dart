import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_quotes_subscription_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_replies_subscription_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_reposts_subscription_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedNotificationsButton extends ConsumerWidget {
  const FeedNotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(notificationRepliesSubscriptionProvider)
      ..watch(notificationQuotesSubscriptionProvider)
      ..watch(notificationRepostsSubscriptionProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        NavigationButton(
          onPressed: () => NotificationsHistoryRoute().push<void>(context),
          icon: Assets.svg.iconHomeNotification.icon(
            color: context.theme.appColors.primaryText,
          ),
        ),
        Positioned(top: -3.0.s, right: -3.0.s, child: const _UnreadCounter()),
      ],
    );
  }
}

class _UnreadCounter extends StatelessWidget {
  const _UnreadCounter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 1.5.s, right: 2.5.s, top: 2.5.s, bottom: 2.5.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.s),
        color: context.theme.appColors.attentionRed,
      ),
      constraints: BoxConstraints(minWidth: 15.0.s),
      child: Text(
        '1',
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption4.copyWith(
          color: context.theme.appColors.primaryBackground,
        ),
      ),
    );
  }
}
