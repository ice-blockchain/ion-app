// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/content_type.d.dart';
import 'package:ion/app/features/feed/notifications/data/repository/account_notification_sync_repository.r.dart';
import 'package:ion/app/features/feed/notifications/data/repository/content_repository.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/event_backfill_service.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.r.dart';
import 'package:ion/app/features/user/model/account_notifications_sets.f.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.r.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.r.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifications_sync_provider.r.g.dart';

@Riverpod(keepAlive: true)
class AccountNotificationsSync extends _$AccountNotificationsSync {
  Timer? _syncTimer;

  @override
  FutureOr<void> build() async {
    await initializeSync();
    ref.onDispose(cancelAllSync);
  }

  Future<void> initializeSync() async {
    final syncInterval = getSyncInterval();

    final lastSyncTime = await getLastSyncTime();

    if (shouldSyncImmediately(lastSyncTime, syncInterval)) {
      await syncAndScheduleNext(syncInterval);
    } else {
      scheduleDelayedSync(lastSyncTime!, syncInterval);
    }
  }

  Duration getSyncInterval() {
    return ref.read(envProvider.notifier).get<Duration>(
          EnvVariable.ACCOUNT_NOTIFICATION_SETTINGS_SYNC_INTERVAL_MINUTES,
        );
  }

  bool shouldSyncImmediately(DateTime? lastSyncTime, Duration syncInterval) {
    if (lastSyncTime == null) return true;

    final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
    return timeSinceLastSync >= syncInterval;
  }

  void scheduleDelayedSync(DateTime lastSyncTime, Duration syncInterval) {
    final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
    final remainingTime = syncInterval - timeSinceLastSync;

    _syncTimer = Timer(remainingTime, () async {
      await syncAndScheduleNext(syncInterval);
    });
  }

  Future<void> syncAndScheduleNext(Duration syncInterval) async {
    await performSync();
    setupPeriodicSync(syncInterval);
  }

  void setupPeriodicSync(Duration interval) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) async {
      await performSync();
    });
  }

  void cancelAllSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<DateTime?> getLastSyncTime() async {
    final repository = ref.read(accountNotificationSyncRepositoryProvider);
    return repository.getLastSyncTime();
  }

  Future<void> performSync() async {
    final authState = await ref.read(authProvider.future);
    if (!authState.isAuthenticated) {
      return;
    }

    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return;
    }

    final contentTypes = await determineContentTypesToSync();
    if (contentTypes.isEmpty) {
      return;
    }

    final usersMap = await getAllUsersFromNotificationSets(contentTypes);

    if (usersMap.isEmpty) {
      return;
    }

    for (final entry in usersMap.entries) {
      final contentType = entry.key;
      final users = entry.value;

      if (users.isEmpty || contentType == UserNotificationsType.none) {
        continue;
      }

      final optimalRelayMapping = await getOptimalRelayMapping(users);

      for (final relayEntry in optimalRelayMapping.entries) {
        await syncEventsFromRelay(
          relayUrl: relayEntry.key,
          users: relayEntry.value,
          contentType: contentType,
        );
      }
    }
  }

  Future<List<UserNotificationsType>> determineContentTypesToSync() async {
    final enabledNotifications = ref.read(userNotificationsNotifierProvider);

    final hasGlobalNotifications = !enabledNotifications.contains(UserNotificationsType.none) &&
        enabledNotifications.isNotEmpty;

    if (hasGlobalNotifications) {
      final types =
          enabledNotifications.where((type) => type != UserNotificationsType.none).toList();
      return types;
    } else {
      final types = await getUserSpecificContentTypes();
      return types;
    }
  }

  Future<List<UserNotificationsType>> getUserSpecificContentTypes() async {
    final userSpecificTypes = <UserNotificationsType>[];
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return userSpecificTypes;
    }

    for (final type in [
      UserNotificationsType.posts,
      UserNotificationsType.stories,
      UserNotificationsType.articles,
      UserNotificationsType.videos,
    ]) {
      final setType = AccountNotificationSetType.fromUserNotificationType(type);
      if (setType == null) {
        continue;
      }

      final accountNotificationSet = await ref.read(
        ionConnectEntityProvider(
          eventReference: ReplaceableEventReference(
            pubkey: currentPubkey,
            kind: AccountNotificationSetEntity.kind,
            dTag: setType.dTagName,
          ),
        ).future,
      );

      if (accountNotificationSet is AccountNotificationSetEntity &&
          accountNotificationSet.data.userPubkeys.isNotEmpty) {
        userSpecificTypes.add(type);
      }
    }

    return userSpecificTypes;
  }

  Future<Map<UserNotificationsType, List<String>>> getAllUsersFromNotificationSets(
    List<UserNotificationsType> contentTypes,
  ) async {
    final result = <UserNotificationsType, List<String>>{};
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return result;
    }

    for (final contentType in contentTypes) {
      if (contentType == UserNotificationsType.none) {
        continue;
      }

      final setType = AccountNotificationSetType.fromUserNotificationType(contentType);
      if (setType == null) {
        continue;
      }

      final accountNotificationSet = await ref.read(
        ionConnectEntityProvider(
          eventReference: ReplaceableEventReference(
            pubkey: currentPubkey,
            kind: AccountNotificationSetEntity.kind,
            dTag: setType.dTagName,
          ),
        ).future,
      );

      if (accountNotificationSet is AccountNotificationSetEntity) {
        final users = accountNotificationSet.data.userPubkeys;
        result[contentType] = users;
      }
    }

    return result;
  }

  Future<Map<String, List<String>>> getOptimalRelayMapping(List<String> users) async {
    final userToRelays = <String, List<String>>{};
    final userRelaysManager = ref.read(userRelaysManagerProvider.notifier);
    final userRelaysList = await userRelaysManager.fetch(users);

    for (final userRelay in userRelaysList) {
      userToRelays[userRelay.masterPubkey] = userRelay.urls;
    }

    final result = findBestOptions(userToRelays);
    return result;
  }

  /// Sync events from a specific relay for a content type
  Future<void> syncEventsFromRelay({
    required String relayUrl,
    required List<String> users,
    required UserNotificationsType contentType,
  }) async {
    if (contentType == UserNotificationsType.none) {
      return;
    }

    await syncContentTypeFromRelay(
      relayUrl: relayUrl,
      users: users,
      contentType: contentType,
    );
  }

  /// Sync a specific content type from a relay
  Future<void> syncContentTypeFromRelay({
    required String relayUrl,
    required List<String> users,
    required UserNotificationsType contentType,
  }) async {
    if (contentType == UserNotificationsType.none) {
      return;
    }

    final repository = ref.read(accountNotificationSyncRepositoryProvider);

    final contentTypeEnum = switch (contentType) {
      UserNotificationsType.posts => ContentType.posts,
      UserNotificationsType.stories => ContentType.stories,
      UserNotificationsType.articles => ContentType.articles,
      UserNotificationsType.videos => ContentType.videos,
      UserNotificationsType.none => throw ArgumentError('Cannot convert none to content type'),
    };

    final syncState = await repository.getSyncState(contentTypeEnum);

    final callStartTime = DateTime.now();

    DateTime latestEventTimestamp;

    if (syncState != null) {
      latestEventTimestamp = syncState;
    } else {
      final setCreationTime = await getNotificationSetCreationTime(contentType);
      latestEventTimestamp = setCreationTime != null
          ? DateTime.fromMicrosecondsSinceEpoch(setCreationTime)
          : callStartTime;
    }

    final requestFilter = buildRequestFilter(
      contentType: contentType,
      users: users,
    );

    if (requestFilter == null) {
      return;
    }

    final eventBackfillService = ref.read(eventBackfillServiceProvider);

    final eventFutures = <Future<void>>[];

    final newLastCreatedAt = await eventBackfillService.startBackfill(
      latestEventTimestamp: latestEventTimestamp.microsecondsSinceEpoch,
      filter: requestFilter,
      onEvent: (event) {
        eventFutures.add(processNotificationEvent(event, contentType));
      },
      actionSource: ActionSourceRelayUrl(relayUrl),
    );

    await Future.wait(eventFutures);

    final actualNewTimestamp = newLastCreatedAt == latestEventTimestamp.microsecondsSinceEpoch
        ? latestEventTimestamp.add(const Duration(microseconds: 1))
        : DateTime.fromMicrosecondsSinceEpoch(newLastCreatedAt);

    await repository.updateSyncState(contentTypeEnum, actualNewTimestamp);
  }

  Future<int?> getNotificationSetCreationTime(UserNotificationsType contentType) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) return null;

    final setType = AccountNotificationSetType.fromUserNotificationType(contentType);
    if (setType == null) return null;

    final notificationSet = await ref.read(
      ionConnectEntityProvider(
        eventReference: ReplaceableEventReference(
          pubkey: currentPubkey,
          kind: AccountNotificationSetEntity.kind,
          dTag: setType.dTagName,
        ),
      ).future,
    );

    return notificationSet is AccountNotificationSetEntity ? notificationSet.createdAt : null;
  }

  RequestFilter? buildRequestFilter({
    required UserNotificationsType contentType,
    required List<String> users,
  }) {
    if (users.isEmpty || contentType == UserNotificationsType.none) {
      return null;
    }

    return switch (contentType) {
      UserNotificationsType.videos => RequestFilter(
          kinds: const [
            PostEntity.kind,
            ModifiablePostEntity.kind,
          ],
          search: VideosSearchExtension(contain: true).query,
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.stories => RequestFilter(
          kinds: const [
            PostEntity.kind,
            ModifiablePostEntity.kind,
          ],
          search: ExpirationSearchExtension(expiration: true).query,
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.articles => RequestFilter(
          kinds: const [
            ArticleEntity.kind,
          ],
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.posts => RequestFilter(
          kinds: const [
            PostEntity.kind,
            ModifiablePostEntity.kind,
          ],
          search: SearchExtensions([
            ExpirationSearchExtension(expiration: false),
            VideosSearchExtension(contain: false),
          ]).toString(),
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.none => throw ArgumentError('Cannot build filter for none type'),
    };
  }

  Future<void> processNotificationEvent(
    EventMessage event,
    UserNotificationsType contentType,
  ) async {
    final entity = convertEventToEntity(event);
    if (entity == null) {
      return;
    }

    await saveToNotificationsDatabase(entity);
  }

  IonConnectEntity? convertEventToEntity(EventMessage event) {
    final entity = ref.read(eventParserProvider).parse(event);
    return entity;
  }

  Future<void> saveToNotificationsDatabase(IonConnectEntity entity) async {
    final contentRepo = ref.read(contentRepositoryProvider);
    await contentRepo.save(entity);
  }
}
