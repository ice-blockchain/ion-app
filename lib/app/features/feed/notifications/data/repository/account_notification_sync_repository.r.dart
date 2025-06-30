// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/account_notification_sync_state_dao.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/account_notification_sync_state_table.d.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notification_sync_repository.r.g.dart';

@Riverpod(keepAlive: true)
AccountNotificationSyncRepository accountNotificationSyncRepository(Ref ref) =>
    AccountNotificationSyncRepository(
      accountNotificationSyncStateDao: ref.watch(accountNotificationSyncStateDaoProvider),
    );

class AccountNotificationSyncRepository {
  AccountNotificationSyncRepository({
    required AccountNotificationSyncStateDao accountNotificationSyncStateDao,
  }) : _dao = accountNotificationSyncStateDao;

  final AccountNotificationSyncStateDao _dao;

  /// Get the timestamp of the last successful sync
  Future<DateTime?> getLastSyncTime() async {
    return _dao.getLastSyncTime();
  }

  /// Get the sync state for a specific content type
  Future<AccountNotificationSyncState?> getSyncState(
    UserNotificationsType contentType,
  ) async {
    final contentTypeEnum = mapToContentTypeEnum(contentType);
    return _dao.getByContentType(
      contentType: contentTypeEnum,
    );
  }

  /// Update the sync state for a specific content type
  Future<void> updateSyncState({
    required UserNotificationsType contentType,
    required int sinceTimestamp,
  }) async {
    final contentTypeEnum = mapToContentTypeEnum(contentType);
    return _dao.insertOrUpdate(
      contentType: contentTypeEnum,
      lastSyncTimestamp: DateTime.now().microsecondsSinceEpoch,
      sinceTimestamp: sinceTimestamp,
    );
  }

  /// Map UserNotificationsType to ContentType enum
  ContentType mapToContentTypeEnum(UserNotificationsType contentType) {
    return switch (contentType) {
      UserNotificationsType.posts => ContentType.posts,
      UserNotificationsType.stories => ContentType.stories,
      UserNotificationsType.articles => ContentType.articles,
      UserNotificationsType.videos => ContentType.videos,
      UserNotificationsType.none => throw ArgumentError('Cannot convert none to content type'),
    };
  }
}
