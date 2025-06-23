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
Future<void> syncAccountNotificationSets(Ref ref) async {
  final authState = await ref.watch(authProvider.future);
  if (!authState.isAuthenticated) {
    return;
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final enabledNotifications = ref.watch(userNotificationsNotifierProvider);

  final currentSets = await _fetchCurrentNotificationSets(ref, currentPubkey);

  await _updateNotificationSets(ref, currentPubkey, enabledNotifications, currentSets);
}

@riverpod
Future<List<String>> usersForNotificationType(
  Ref ref,
  UserNotificationsType notificationType,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null || notificationType == UserNotificationsType.none) {
    return [];
  }

  final setType = _getSetTypeForNotificationType(notificationType);
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
            '#d': [setType],
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

Future<Map<String, List<String>>> _fetchCurrentNotificationSets(
  Ref ref,
  String currentPubkey,
) async {
  final sets = <String, List<String>>{};

  final setTypes = [
    'in_app_notifications_posts',
    'in_app_notifications_stories',
    'in_app_notifications_articles',
    'in_app_notifications_videos',
  ];

  for (final setType in setTypes) {
    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [AccountNotificationSetEntity.kind],
          authors: [currentPubkey],
          tags: {
            '#d': [setType],
          },
          limit: 1,
        ),
      );

    try {
      final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
      final eventsStream = ionConnectNotifier.requestEvents(requestMessage);

      await for (final event in eventsStream) {
        final userPubkeys = event.tags
            .where((List<String> tag) => tag.isNotEmpty && tag[0] == 'p' && tag.length > 1)
            .map((List<String> tag) => tag[1])
            .toList();

        sets[setType] = userPubkeys;
        break;
      }
    } catch (error) {
      sets[setType] = [];
    }
  }

  return sets;
}

Future<void> _updateNotificationSets(
  Ref ref,
  String currentPubkey,
  List<UserNotificationsType> enabledNotifications,
  Map<String, List<String>> currentSets,
) async {
  final setTypesToUsers = <String, List<String>>{
    'in_app_notifications_posts': [],
    'in_app_notifications_stories': [],
    'in_app_notifications_articles': [],
    'in_app_notifications_videos': [],
  };

  if (enabledNotifications.contains(UserNotificationsType.none) || enabledNotifications.isEmpty) {
    setTypesToUsers['in_app_notifications_posts'] = [];
    setTypesToUsers['in_app_notifications_stories'] = [];
    setTypesToUsers['in_app_notifications_articles'] = [];
    setTypesToUsers['in_app_notifications_videos'] = [];
  } else {
    for (final entry in currentSets.entries) {
      final setType = entry.key;
      final notificationType = _getNotificationTypeForSetType(setType);

      if (notificationType != null && enabledNotifications.contains(notificationType)) {
        setTypesToUsers[setType] = entry.value;
      } else {
        setTypesToUsers[setType] = [];
      }
    }
  }

  for (final entry in setTypesToUsers.entries) {
    final setType = entry.key;
    final userPubkeys = entry.value;

    await _updateNotificationSet(
      ref,
      currentPubkey,
      setType,
      userPubkeys,
    );
  }
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

UserNotificationsType? _getNotificationTypeForSetType(String setType) {
  return switch (setType) {
    'in_app_notifications_posts' => UserNotificationsType.posts,
    'in_app_notifications_stories' => UserNotificationsType.stories,
    'in_app_notifications_articles' => UserNotificationsType.articles,
    'in_app_notifications_videos' => UserNotificationsType.videos,
    _ => null,
  };
}

String? _getSetTypeForNotificationType(UserNotificationsType notificationType) {
  return switch (notificationType) {
    UserNotificationsType.posts => 'in_app_notifications_posts',
    UserNotificationsType.stories => 'in_app_notifications_stories',
    UserNotificationsType.articles => 'in_app_notifications_articles',
    UserNotificationsType.videos => 'in_app_notifications_videos',
    UserNotificationsType.none => null,
  };
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
