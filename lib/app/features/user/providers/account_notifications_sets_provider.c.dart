// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/account_notifications_sets.c.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifications_sets_provider.c.g.dart';

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

Future<void> _updateNotificationSet(
  Ref ref,
  String currentPubkey,
  String setType,
  List<String> userPubkeys,
) async {
  final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);

  final setData = AccountNotificationSetData(
    type: AccountNotificationSetType.values.firstWhere(
      (t) => t.dTagName == setType,
      orElse: () => AccountNotificationSetType.posts,
    ),
    userPubkeys: userPubkeys,
  );

  final eventMessage = await ionConnectNotifier.sign(setData);
  await ionConnectNotifier.sendEvent(eventMessage);
}

String? _getSetTypeForNotificationType(UserNotificationsType notificationType) {
  final setType = AccountNotificationSetType.fromUserNotificationType(notificationType);
  return setType?.dTagName;
}

Future<void> addUserToNotificationSet(
  Ref ref,
  String userPubkey,
  UserNotificationsType notificationType,
) async {
  final currentPubkey = ref.read(currentPubkeySelectorProvider);
  if (currentPubkey == null || notificationType == UserNotificationsType.none) {
    return;
  }

  final setType = _getSetTypeForNotificationType(notificationType);
  if (setType == null) {
    return;
  }

  final currentUsers = await ref.read(usersForNotificationTypeProvider(notificationType).future);

  final updatedUsers =
      currentUsers.contains(userPubkey) ? currentUsers : [...currentUsers, userPubkey];

  await _updateNotificationSet(ref, currentPubkey, setType, updatedUsers);

  ref.invalidate(usersForNotificationTypeProvider(notificationType));
}

Future<void> removeUserFromNotificationSet(
  Ref ref,
  String userPubkey,
  UserNotificationsType notificationType,
) async {
  final currentPubkey = ref.read(currentPubkeySelectorProvider);
  if (currentPubkey == null || notificationType == UserNotificationsType.none) {
    return;
  }

  final setType = _getSetTypeForNotificationType(notificationType);
  if (setType == null) {
    return;
  }

  final currentUsers = await ref.read(usersForNotificationTypeProvider(notificationType).future);

  final updatedUsers = currentUsers.where((pubkey) => pubkey != userPubkey).toList();

  await _updateNotificationSet(ref, currentPubkey, setType, updatedUsers);

  ref.invalidate(usersForNotificationTypeProvider(notificationType));
}
