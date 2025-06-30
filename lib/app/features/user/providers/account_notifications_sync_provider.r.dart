// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.f.dart';
import 'package:ion/app/features/feed/notifications/data/repository/account_notification_sync_repository.r.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.r.dart';
import 'package:ion/app/features/feed/notifications/data/repository/content_repository.r.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
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

  /// Initialize the sync process, considering the last sync time
  Future<void> initializeSync() async {
    final syncInterval = getSyncInterval();
    final lastSyncTime = await getLastSyncTime();

    if (shouldSyncImmediately(lastSyncTime, syncInterval)) {
      await syncAndScheduleNext(syncInterval);
    } else {
      scheduleDelayedSync(lastSyncTime!, syncInterval);
    }
  }

  /// Get the configured sync interval from environment
  Duration getSyncInterval() {
    return ref.read(envProvider.notifier).get<Duration>(
          EnvVariable.ACCOUNT_NOTIFICATION_SETTINGS_SYNC_INTERVAL_MINUTES,
        );
  }

  /// Check if we should sync immediately based on last sync time
  bool shouldSyncImmediately(DateTime? lastSyncTime, Duration syncInterval) {
    if (lastSyncTime == null) return true;

    final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
    return timeSinceLastSync >= syncInterval;
  }

  /// Schedule a sync after a delay, then set up periodic sync
  void scheduleDelayedSync(DateTime lastSyncTime, Duration syncInterval) {
    final timeSinceLastSync = DateTime.now().difference(lastSyncTime);
    final remainingTime = syncInterval - timeSinceLastSync;

    _syncTimer = Timer(remainingTime, () async {
      await syncAndScheduleNext(syncInterval);
    });
  }

  /// Perform a sync and schedule the next periodic sync
  Future<void> syncAndScheduleNext(Duration syncInterval) async {
    await performSync();
    setupPeriodicSync(syncInterval);
  }

  /// Set up a periodic timer for regular syncs
  void setupPeriodicSync(Duration interval) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) async {
      await performSync();
    });
  }

  /// Cancel all sync operations
  void cancelAllSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Get the timestamp of the last successful sync
  Future<DateTime?> getLastSyncTime() async {
    final repository = ref.read(accountNotificationSyncRepositoryProvider);
    return repository.getLastSyncTime();
  }

  /// Perform the actual sync operation
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

    // Collect all users from all types
    final allUsers = <String>{};
    for (final users in usersMap.values) {
      allUsers.addAll(users);
    }

    if (allUsers.isEmpty) {
      return;
    }

    final optimalRelayMapping = await getOptimalRelayMapping(allUsers.toList());

    // For each content type, sync only its specific users
    for (final entry in usersMap.entries) {
      final contentType = entry.key;
      final users = entry.value;

      if (users.isEmpty || contentType == UserNotificationsType.none) {
        continue;
      }

      // Filter relay mapping for just these users
      final filteredMapping = <String, List<String>>{};
      for (final relayEntry in optimalRelayMapping.entries) {
        final relayUrl = relayEntry.key;
        final relayUsers = relayEntry.value.where(users.contains).toList();

        if (relayUsers.isNotEmpty) {
          filteredMapping[relayUrl] = relayUsers;
        }
      }

      // Sync only this content type with its specific users
      for (final relayEntry in filteredMapping.entries) {
        await syncEventsFromRelay(
          relayUrl: relayEntry.key,
          users: relayEntry.value,
          contentTypes: [contentType],
        );
      }
    }
  }

  /// Determine which content types need to be synced
  Future<List<UserNotificationsType>> determineContentTypesToSync() async {
    final enabledNotifications = ref.read(userNotificationsNotifierProvider);
    final hasGlobalNotifications = !enabledNotifications.contains(UserNotificationsType.none) &&
        enabledNotifications.isNotEmpty;

    if (hasGlobalNotifications) {
      return enabledNotifications.where((type) => type != UserNotificationsType.none).toList();
    } else {
      return getUserSpecificContentTypes();
    }
  }

  /// Get content types that have user-specific notifications
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

  /// Get all users from notification sets for the given content types
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
        result[contentType] = accountNotificationSet.data.userPubkeys;
      }
    }
    return result;
  }

  /// Get the optimal mapping of relays to users
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

  /// Sync events from a specific relay for all content types
  Future<void> syncEventsFromRelay({
    required String relayUrl,
    required List<String> users,
    required List<UserNotificationsType> contentTypes,
  }) async {
    for (final contentType in contentTypes) {
      if (contentType == UserNotificationsType.none) {
        continue;
      }

      await syncContentTypeFromRelay(
        relayUrl: relayUrl,
        users: users,
        contentType: contentType,
      );
    }
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
    final syncState = await repository.getSyncState(contentType);
    final callStartTime = DateTime.now().microsecondsSinceEpoch;

    // Determine the starting timestamp for events
    int latestEventTimestamp;

    // If we have a saved sync state, use it
    if (syncState != null && syncState.sinceTimestamp != null) {
      latestEventTimestamp = syncState.sinceTimestamp!;
    } else {
      // Otherwise, get timestamp from when the notification set was created
      latestEventTimestamp = await getNotificationSetCreationTime(contentType) ?? callStartTime;
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
      latestEventTimestamp: latestEventTimestamp,
      filter: requestFilter,
      onEvent: (event) {
        eventFutures.add(processNotificationEvent(event, contentType));
      },
      actionSource: ActionSourceRelayUrl(relayUrl),
    );
    await Future.wait(eventFutures);

    final actualNewTimestamp =
        newLastCreatedAt == latestEventTimestamp ? latestEventTimestamp + 1 : newLastCreatedAt;

    await repository.updateSyncState(
      contentType: contentType,
      sinceTimestamp: actualNewTimestamp,
    );
  }

  /// Get the creation timestamp of a notification set
  Future<int?> getNotificationSetCreationTime(UserNotificationsType contentType) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) return null;

    final setType = AccountNotificationSetType.fromUserNotificationType(contentType);
    if (setType == null) return null;

    final notificationSet = await ref
        .read(
          ionConnectEntityProvider(
            eventReference: ReplaceableEventReference(
              pubkey: currentPubkey,
              kind: AccountNotificationSetEntity.kind,
              dTag: setType.dTagName,
            ),
          ).future,
        )
        .catchError((_) => null);

    return notificationSet is AccountNotificationSetEntity ? notificationSet.createdAt : null;
  }

  /// Build a request filter for the given content type and users
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
            RepostEntity.kind,
            ModifiablePostEntity.kind,
            GenericRepostEntity.modifiablePostRepostKind,
          ],
          search: 'videos:true',
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.stories => RequestFilter(
          kinds: const [
            PostEntity.kind,
            RepostEntity.kind,
            ModifiablePostEntity.kind,
            GenericRepostEntity.modifiablePostRepostKind,
          ],
          search: 'expiration:true',
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.articles => RequestFilter(
          kinds: const [
            ArticleEntity.kind,
            GenericRepostEntity.articleRepostKind,
          ],
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.posts => RequestFilter(
          kinds: const [
            PostEntity.kind,
            RepostEntity.kind,
            ModifiablePostEntity.kind,
            GenericRepostEntity.modifiablePostRepostKind,
          ],
          search: 'videos:false expiration:false',
          authors: users,
          limit: 100,
        ),
      UserNotificationsType.none => throw ArgumentError('Cannot build filter for none type'),
    };
  }

  /// Process a notification event
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

  /// Convert an event message to an entity
  IonConnectEntity? convertEventToEntity(EventMessage event) {
    try {
      return ref.read(eventParserProvider).parse(event);
    } catch (error) {
      return null;
    }
  }

  /// Save an entity to the notifications database
  Future<void> saveToNotificationsDatabase(IonConnectEntity entity) async {
    if (entity is ReactionEntity) {
      final likesRepo = ref.read(likesRepositoryProvider);
      await likesRepo.save(entity);
    } else if (entity is PostEntity || entity is ArticleEntity || entity is ModifiablePostEntity) {
      final contentRepo = ref.read(contentRepositoryProvider);
      await contentRepo.save(entity);
    } else if (entity is GenericRepostEntity) {
      final commentsRepo = ref.read(commentsRepositoryProvider);
      await commentsRepo.save(entity);
    }
  }
}
