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
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/data/database/account_notifications_database.c.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.c.dart';
import 'package:ion/app/features/user/providers/account_notifications_sets_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/local_notifications/local_notifications.c.dart';
import 'package:ion/app/services/logger/logger.dart';
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
    final syncIntervalMinutes = ref.read(envProvider.notifier).get<int>(
          EnvVariable.ACCOUNT_NOTIFICATION_SETTINGS_SYNC_INTERVAL_MINUTES,
        );
    final syncInterval = Duration(minutes: syncIntervalMinutes);

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
    try {
      final authState = await ref.read(authProvider.future);
      if (!authState.isAuthenticated) {
        return;
      }

      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        return;
      }

      final enabledNotifications = ref.read(userNotificationsNotifierProvider);
      if (enabledNotifications.contains(UserNotificationsType.none) ||
          enabledNotifications.isEmpty) {
        return;
      }

      final contentTypes = enabledNotifications
          .where((type) => type != UserNotificationsType.none)
          .map(NotificationContentType.fromUserNotificationType)
          .toList();

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
    } catch (error, stackTrace) {
      Logger.error('Account notifications sync error: $error', stackTrace: stackTrace);
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

      try {
        final users = await ref.read(usersForNotificationTypeProvider(notificationType).future);
        allUsers.addAll(users);
      } catch (error) {
        Logger.error('Error fetching users for $notificationType: $error');
      }
    }

    return allUsers.toList();
  }

  Future<void> _cacheUserRelays(List<String> users, AccountNotificationsDatabase database) async {
    // TODO: Add periodic relay list refresh/sync for users in the future
    // Currently we only fetch relay lists when enabling notifications for a user
    // but we should periodically refresh them to ensure we have up-to-date relay information

    try {
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
    } catch (error, stackTrace) {
      Logger.error('Error caching relays for users: $error', stackTrace: stackTrace);
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

    return findBestOptions(userToRelays);
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
    var hasMoreEvents = true;
    var requestCount = 0;
    var maxCreatedAt = 0;

    final callStartTime = DateTime.now().microsecondsSinceEpoch;

    while (hasMoreEvents && requestCount < 10) {
      requestCount++;

      final syncState = await _getSyncState(relayUrl, contentType, database);

      final requestFilter = _buildRequestFilter(
        contentType: contentType,
        users: users,
        since: syncState?.sinceTimestamp,
        until: requestCount == 1 ? null : maxCreatedAt,
      );

      if (requestFilter == null) {
        return;
      }

      final requestMessage = RequestMessage()..addFilter(requestFilter);

      try {
        final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
        final eventsStream = ionConnectNotifier.requestEvents(
          requestMessage,
          actionSource: ActionSourceRelayUrl(relayUrl),
        );

        var eventsInThisRequest = 0;
        var minCreatedAtInRequest = 0;

        await for (final event in eventsStream) {
          eventsInThisRequest++;

          if (minCreatedAtInRequest == 0 || event.createdAt < minCreatedAtInRequest) {
            minCreatedAtInRequest = event.createdAt;
          }

          if (event.createdAt > maxCreatedAt) {
            maxCreatedAt = event.createdAt;
          }

          await _processNotificationEvent(event, contentType);
        }

        if (eventsInThisRequest == 0) {
          hasMoreEvents = false;

          await _updateSyncState(
            relayUrl: relayUrl,
            contentType: contentType,
            database: database,
            sinceTimestamp: callStartTime,
          );

          Logger.log('No new events for $contentType from $relayUrl after $requestCount requests');
        } else {
          maxCreatedAt = minCreatedAtInRequest;

          hasMoreEvents = eventsInThisRequest >= 100;

          await _updateSyncState(
            relayUrl: relayUrl,
            contentType: contentType,
            database: database,
            sinceTimestamp: maxCreatedAt,
          );
        }
      } catch (error) {
        hasMoreEvents = false;
      }
    }
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
    int? since,
    int? until,
  }) {
    if (users.isEmpty) {
      return null;
    }

    return switch (contentType) {
      NotificationContentType.videos => RequestFilter(
          kinds: const [1, 6, 30175, 1630175],
          search: 'videos:true',
          authors: users,
          limit: 100,
          since: since,
          until: until,
        ),
      NotificationContentType.stories => RequestFilter(
          kinds: const [1, 6, 30175, 1630175],
          search: 'expiration:true',
          authors: users,
          limit: 100,
          since: since,
          until: until,
        ),
      NotificationContentType.articles => RequestFilter(
          kinds: const [30023, 1630023],
          authors: users,
          limit: 100,
          since: since,
          until: until,
        ),
      NotificationContentType.posts => RequestFilter(
          kinds: const [1, 6, 30175, 1630175],
          search: 'videos:false expiration:false',
          authors: users,
          limit: 100,
          since: since,
          until: until,
        ),
    };
  }

  Future<void> _processNotificationEvent(
    EventMessage event,
    NotificationContentType contentType,
  ) async {
    try {
      final entity = _convertEventToEntity(event);
      if (entity == null) {
        Logger.log('Unsupported event kind ${event.kind} for notifications');
        return;
      }

      await _saveToNotificationsDatabase(entity);

      await _triggerLocalNotification(entity, contentType);
    } catch (error) {
      Logger.error('Error processing notification event: $error');
    }
  }

  IonConnectEntity? _convertEventToEntity(EventMessage event) {
    try {
      return switch (event.kind) {
        1 => PostEntity.fromEventMessage(event),
        6 => RepostEntity.fromEventMessage(event),
        7 => ReactionEntity.fromEventMessage(event),
        30023 => ArticleEntity.fromEventMessage(event),
        30175 => ModifiablePostEntity.fromEventMessage(event),
        1630023 => GenericRepostEntity.fromEventMessage(event),
        1630175 => GenericRepostEntity.fromEventMessage(event),
        _ => null,
      };
    } catch (error) {
      Logger.error('Error converting event ${event.id} to entity: $error');
      return null;
    }
  }

  Future<void> _saveToNotificationsDatabase(IonConnectEntity entity) async {
    try {
      switch (entity.runtimeType) {
        case ReactionEntity:
          final likesRepo = ref.read(likesRepositoryProvider);
          await likesRepo.save(entity);
        case ModifiablePostEntity:
        case GenericRepostEntity:
          final commentsRepo = ref.read(commentsRepositoryProvider);
          await commentsRepo.save(entity);
        default:
          Logger.log('No specific repository handler for ${entity.runtimeType}');
      }
    } catch (error, stackTrace) {
      Logger.error('Error saving to notifications database: $error', stackTrace: stackTrace);
    }
  }

  Future<void> _triggerLocalNotification(
    IonConnectEntity entity,
    NotificationContentType contentType,
  ) async {
    try {
      final localNotifications = await ref.read(localNotificationsServiceProvider.future);

      final title = switch (contentType) {
        NotificationContentType.posts => 'New Post',
        NotificationContentType.stories => 'New Story',
        NotificationContentType.articles => 'New Article',
        NotificationContentType.videos => 'New Video',
      };

      final body = switch (entity.runtimeType) {
        ReactionEntity => 'Someone reacted to your content',
        ModifiablePostEntity => 'New post from someone you follow',
        GenericRepostEntity => 'Someone shared content',
        _ => 'New notification from someone you follow',
      };

      await localNotifications.showNotification(
        id: entity.id.hashCode,
        title: title,
        body: body,
        payload: entity.id,
      );
    } catch (error, stackTrace) {
      Logger.error('Error triggering local notification: $error', stackTrace: stackTrace);
    }
  }
}
