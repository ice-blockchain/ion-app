// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/content_repository.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/event_backfill_service.c.dart';
import 'package:ion/app/features/user/data/database/account_notifications_database.c.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.c.dart';
import 'package:ion/app/features/user/providers/account_notifications_sets_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifications_sync_provider.c.g.dart';

enum NotificationContentType {
  posts,
  stories,
  articles,
  videos;

  String get filterName => switch (this) {
        NotificationContentType.posts => 'posts',
        NotificationContentType.stories => 'stories',
        NotificationContentType.articles => 'articles',
        NotificationContentType.videos => 'videos',
      };

  static NotificationContentType fromUserNotificationType(UserNotificationsType type) {
    return switch (type) {
      UserNotificationsType.posts => NotificationContentType.posts,
      UserNotificationsType.stories => NotificationContentType.stories,
      UserNotificationsType.articles => NotificationContentType.articles,
      UserNotificationsType.videos => NotificationContentType.videos,
      UserNotificationsType.none => throw ArgumentError('Cannot convert none to content type'),
    };
  }
}

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
    final database = ref.read(accountNotificationsDatabaseProvider);
    final query = database.select(database.accountNotificationSyncStateTable)
      ..orderBy([(t) => OrderingTerm.desc(t.lastSyncTimestamp)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result?.lastSyncTimestamp != null
        ? DateTime.fromMicrosecondsSinceEpoch(result!.lastSyncTimestamp)
        : null;
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

    final database = ref.read(accountNotificationsDatabaseProvider);
    final allUsers = await getAllUsersFromNotificationSets(contentTypes);

    if (allUsers.isEmpty) {
      return;
    }

    await cacheUserRelays(allUsers, database);
    final optimalRelayMapping = await getOptimalRelayMapping(allUsers, database);

    await syncFromAllRelays(optimalRelayMapping, contentTypes, database);
  }

  /// Determine which content types need to be synced
  Future<List<NotificationContentType>> determineContentTypesToSync() async {
    final enabledNotifications = ref.read(userNotificationsNotifierProvider);
    final hasGlobalNotifications = !enabledNotifications.contains(UserNotificationsType.none) &&
        enabledNotifications.isNotEmpty;

    if (hasGlobalNotifications) {
      return enabledNotifications
          .where((type) => type != UserNotificationsType.none)
          .map(NotificationContentType.fromUserNotificationType)
          .toList();
    } else {
      return getUserSpecificContentTypes();
    }
  }

  /// Get content types that have user-specific notifications
  Future<List<NotificationContentType>> getUserSpecificContentTypes() async {
    final userSpecificTypes = <NotificationContentType>[];

    for (final type in [
      UserNotificationsType.posts,
      UserNotificationsType.stories,
      UserNotificationsType.articles,
      UserNotificationsType.videos,
    ]) {
      final users = await ref.read(usersForNotificationTypeProvider(type).future);
      if (users.isNotEmpty) {
        userSpecificTypes.add(NotificationContentType.fromUserNotificationType(type));
      }
    }

    return userSpecificTypes;
  }

  /// Sync from all relays in the mapping
  Future<void> syncFromAllRelays(
    Map<String, List<String>> relayMapping,
    List<NotificationContentType> contentTypes,
    AccountNotificationsDatabase database,
  ) async {
    for (final entry in relayMapping.entries) {
      await syncEventsFromRelay(
        relayUrl: entry.key,
        users: entry.value,
        contentTypes: contentTypes,
        database: database,
      );
    }
  }

  /// Get all users from notification sets for the given content types
  Future<List<String>> getAllUsersFromNotificationSets(
    List<NotificationContentType> contentTypes,
  ) async {
    final allUsers = <String>{};

    for (final contentType in contentTypes) {
      final notificationType = switch (contentType) {
        NotificationContentType.posts => UserNotificationsType.posts,
        NotificationContentType.stories => UserNotificationsType.stories,
        NotificationContentType.articles => UserNotificationsType.articles,
        NotificationContentType.videos => UserNotificationsType.videos,
      };

      final users = await ref.read(usersForNotificationTypeProvider(notificationType).future);
      allUsers.addAll(users);
    }
    return allUsers.toList();
  }

  /// Cache relay information for users
  Future<void> cacheUserRelays(List<String> users, AccountNotificationsDatabase database) async {
    final userRelaysManager = ref.read(userRelaysManagerProvider.notifier);
    final userRelaysList = await userRelaysManager.fetch(users);

    for (final userRelay in userRelaysList) {
      final relayUrls = json.encode(userRelay.urls);
      await database.into(database.notificationUserRelaysTable).insertOnConflictUpdate(
            NotificationUserRelaysTableCompanion.insert(
              userPubkey: userRelay.masterPubkey,
              relayUrls: relayUrls,
              cachedAt: DateTime.now().microsecondsSinceEpoch,
            ),
          );
    }
  }

  /// Get the optimal mapping of relays to users
  Future<Map<String, List<String>>> getOptimalRelayMapping(
    List<String> users,
    AccountNotificationsDatabase database,
  ) async {
    final userToRelays = <String, List<String>>{};

    final cachedRelays = await database.select(database.notificationUserRelaysTable).get();

    for (final cached in cachedRelays) {
      if (users.contains(cached.userPubkey)) {
        final relayUrls = (json.decode(cached.relayUrls) as List<dynamic>).cast<String>();
        userToRelays[cached.userPubkey] = relayUrls;
      }
    }
    final result = findBestOptions(userToRelays);

    return result;
  }

  /// Sync events from a specific relay for all content types
  Future<void> syncEventsFromRelay({
    required String relayUrl,
    required List<String> users,
    required List<NotificationContentType> contentTypes,
    required AccountNotificationsDatabase database,
  }) async {
    for (final contentType in contentTypes) {
      await syncContentTypeFromRelay(
        relayUrl: relayUrl,
        users: users,
        contentType: contentType,
        database: database,
      );
    }
  }

  /// Sync a specific content type from a relay
  Future<void> syncContentTypeFromRelay({
    required String relayUrl,
    required List<String> users,
    required NotificationContentType contentType,
    required AccountNotificationsDatabase database,
  }) async {
    final syncState = await getSyncState(relayUrl, contentType, database);
    final callStartTime = DateTime.now().microsecondsSinceEpoch;

    final requestFilter = buildRequestFilter(
      contentType: contentType,
      users: users,
    );

    if (requestFilter == null) {
      return;
    }

    final latestEventTimestamp = syncState?.sinceTimestamp ?? callStartTime;

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

    await updateSyncState(
      relayUrl: relayUrl,
      contentType: contentType,
      database: database,
      sinceTimestamp: actualNewTimestamp,
    );
  }

  /// Get the sync state for a specific relay and content type
  Future<AccountNotificationSyncState?> getSyncState(
    String relayUrl,
    NotificationContentType contentType,
    AccountNotificationsDatabase database,
  ) async {
    final query = database.select(database.accountNotificationSyncStateTable)
      ..where((t) => t.relayUrl.equals(relayUrl) & t.contentType.equals(contentType.filterName));

    return query.getSingleOrNull();
  }

  /// Update the sync state for a specific relay and content type
  Future<void> updateSyncState({
    required String relayUrl,
    required NotificationContentType contentType,
    required AccountNotificationsDatabase database,
    required int sinceTimestamp,
  }) async {
    await database.into(database.accountNotificationSyncStateTable).insertOnConflictUpdate(
          AccountNotificationSyncStateTableCompanion.insert(
            relayUrl: relayUrl,
            contentType: contentType.filterName,
            lastSyncTimestamp: DateTime.now().microsecondsSinceEpoch,
            sinceTimestamp: Value(sinceTimestamp),
          ),
        );
  }

  /// Build a request filter for the given content type and users
  RequestFilter? buildRequestFilter({
    required NotificationContentType contentType,
    required List<String> users,
  }) {
    if (users.isEmpty) {
      return null;
    }

    return switch (contentType) {
      NotificationContentType.videos => RequestFilter(
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
      NotificationContentType.stories => RequestFilter(
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
      NotificationContentType.articles => RequestFilter(
          kinds: const [
            ArticleEntity.kind,
            GenericRepostEntity.articleRepostKind,
          ],
          authors: users,
          limit: 100,
        ),
      NotificationContentType.posts => RequestFilter(
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
    };
  }

  /// Process a notification event
  Future<void> processNotificationEvent(
    EventMessage event,
    NotificationContentType contentType,
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
      final entity = switch (event.kind) {
        PostEntity.kind => PostEntity.fromEventMessage(event),
        RepostEntity.kind => RepostEntity.fromEventMessage(event),
        ReactionEntity.kind => ReactionEntity.fromEventMessage(event),
        ArticleEntity.kind => ArticleEntity.fromEventMessage(event),
        ModifiablePostEntity.kind => ModifiablePostEntity.fromEventMessage(event),
        GenericRepostEntity.articleRepostKind => GenericRepostEntity.fromEventMessage(event),
        GenericRepostEntity.modifiablePostRepostKind => GenericRepostEntity.fromEventMessage(event),
        _ => null,
      };

      return entity;
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
