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
  FutureOr<void> build() {
    _startPeriodicSync();
    ref.onDispose(_stopPeriodicSync);
  }

  void _startPeriodicSync() {
    final syncInterval = ref.read(envProvider.notifier).get<Duration>(
          EnvVariable.ACCOUNT_NOTIFICATION_SETTINGS_SYNC_INTERVAL_MINUTES,
        );

    _syncTimer = Timer.periodic(syncInterval, (_) {
      _performSync();
    });

    _performSync();
  }

  void _stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _performSync() async {
    final authState = await ref.read(authProvider.future);
    if (!authState.isAuthenticated) {
      return;
    }

    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return;
    }

    final enabledNotifications = ref.read(userNotificationsNotifierProvider);

    final hasGlobalNotifications = !enabledNotifications.contains(UserNotificationsType.none) &&
        enabledNotifications.isNotEmpty;

    var contentTypes = <NotificationContentType>[];

    if (hasGlobalNotifications) {
      contentTypes = enabledNotifications
          .where((type) => type != UserNotificationsType.none)
          .map(NotificationContentType.fromUserNotificationType)
          .toList();
    } else {
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

      contentTypes = userSpecificTypes;
    }

    if (contentTypes.isEmpty) {
      return;
    }

    final database = ref.read(accountNotificationsDatabaseProvider);

    final allUsers = await _getAllUsersFromNotificationSets(contentTypes);
    if (allUsers.isEmpty) {
      return;
    }

    await _cacheUserRelays(allUsers, database);

    final optimalRelayMapping = await _getOptimalRelayMapping(allUsers, database);

    for (final entry in optimalRelayMapping.entries) {
      final relayUrl = entry.key;
      final users = entry.value;

      await _syncEventsFromRelay(
        relayUrl: relayUrl,
        users: users,
        contentTypes: contentTypes,
        database: database,
      );
    }
  }

  Future<List<String>> _getAllUsersFromNotificationSets(
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

  Future<void> _cacheUserRelays(List<String> users, AccountNotificationsDatabase database) async {
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

  Future<Map<String, List<String>>> _getOptimalRelayMapping(
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

  Future<void> _syncEventsFromRelay({
    required String relayUrl,
    required List<String> users,
    required List<NotificationContentType> contentTypes,
    required AccountNotificationsDatabase database,
  }) async {
    for (final contentType in contentTypes) {
      await _syncContentTypeFromRelay(
        relayUrl: relayUrl,
        users: users,
        contentType: contentType,
        database: database,
      );
    }
  }

  Future<void> _syncContentTypeFromRelay({
    required String relayUrl,
    required List<String> users,
    required NotificationContentType contentType,
    required AccountNotificationsDatabase database,
  }) async {
    final syncState = await _getSyncState(relayUrl, contentType, database);
    final callStartTime = DateTime.now().microsecondsSinceEpoch;

    final requestFilter = _buildRequestFilter(
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
        eventFutures.add(_processNotificationEvent(event, contentType));
      },
      actionSource: ActionSourceRelayUrl(relayUrl),
    );
    await Future.wait(eventFutures);

    final actualNewTimestamp =
        newLastCreatedAt == latestEventTimestamp ? latestEventTimestamp + 1 : newLastCreatedAt;

    await _updateSyncState(
      relayUrl: relayUrl,
      contentType: contentType,
      database: database,
      sinceTimestamp: actualNewTimestamp,
    );
  }

  Future<AccountNotificationSyncState?> _getSyncState(
    String relayUrl,
    NotificationContentType contentType,
    AccountNotificationsDatabase database,
  ) async {
    final query = database.select(database.accountNotificationSyncStateTable)
      ..where((t) => t.relayUrl.equals(relayUrl) & t.contentType.equals(contentType.filterName));

    return query.getSingleOrNull();
  }

  Future<void> _updateSyncState({
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

  RequestFilter? _buildRequestFilter({
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

  Future<void> _processNotificationEvent(
    EventMessage event,
    NotificationContentType contentType,
  ) async {
    final entity = _convertEventToEntity(event);
    if (entity == null) {
      return;
    }

    await _saveToNotificationsDatabase(entity);
  }

  IonConnectEntity? _convertEventToEntity(EventMessage event) {
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

  Future<void> _saveToNotificationsDatabase(IonConnectEntity entity) async {
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
