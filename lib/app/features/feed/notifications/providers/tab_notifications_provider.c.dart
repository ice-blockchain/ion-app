// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/models/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/models/notifications_tab_type.dart';
import 'package:ion/app/features/feed/notifications/providers/all_notifications_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/comments_notifications_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/followers_notifications_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/likes_notifications_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_notifications_provider.c.g.dart';

@riverpod
Future<List<IonNotification>?> tabNotifications(
  Ref ref, {
  required NotificationsTabType type,
}) async {
  return switch (type) {
    NotificationsTabType.all => ref.watch(allNotificationsProvider.future),
    NotificationsTabType.comments => ref.watch(commentsNotificationsProvider.future),
    NotificationsTabType.followers => ref.watch(followersNotificationsProvider.future),
    NotificationsTabType.likes => ref.watch(likesNotificationsProvider.future)
  };
}
