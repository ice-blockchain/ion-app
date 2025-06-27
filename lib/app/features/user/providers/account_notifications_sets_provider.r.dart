// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/account_notifications_sets.f.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifications_sets_provider.r.g.dart';

@riverpod
Future<List<String>> usersForNotificationType(
  Ref ref,
  UserNotificationsType notificationType,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null || notificationType == UserNotificationsType.none) {
    return [];
  }

  final setType = AccountNotificationSetType.fromUserNotificationType(notificationType);
  if (setType == null) {
    return [];
  }

  try {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [AccountNotificationSetEntity.kind],
          authors: [currentPubkey],
          tags: {
            '#d': [setType.dTagName],
          },
          limit: 1,
        ),
      );

    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
    final eventsStream = ionConnectNotifier.requestEvents(requestMessage);

    await for (final event in eventsStream) {
      final userPubkeys = event.tags
          .where((List<String> tag) => tag.isNotEmpty && tag[0] == 'p' && tag.length > 1)
          .map((List<String> tag) => tag[1])
          .toList();

      return userPubkeys;
    }
  } catch (error) {
    return [];
  }

  return [];
}
