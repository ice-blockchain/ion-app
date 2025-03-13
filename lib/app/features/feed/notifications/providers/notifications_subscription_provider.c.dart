// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_quotes_subscription_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_replies_subscription_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_reposts_subscription_provider.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_subscription_provider.c.g.dart';

@riverpod
void notificationsSubscription(Ref ref) {
  ref
    ..watch(notificationRepliesSubscriptionProvider)
    ..watch(notificationQuotesSubscriptionProvider)
    ..watch(notificationRepostsSubscriptionProvider);
}
