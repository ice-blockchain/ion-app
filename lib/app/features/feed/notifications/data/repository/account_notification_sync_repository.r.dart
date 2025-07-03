// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/account_notification_sync_state_dao.m.dart';
import 'package:ion/app/features/feed/notifications/data/model/content_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notification_sync_repository.r.g.dart';

@riverpod
AccountNotificationSyncRepository accountNotificationSyncRepository(
  Ref ref,
) {
  return AccountNotificationSyncRepository(
    syncStateDao: ref.watch(accountNotificationSyncStateDaoProvider),
    currentPubkey: ref.watch(currentPubkeySelectorProvider),
  );
}

class AccountNotificationSyncRepository {
  const AccountNotificationSyncRepository({
    required this.syncStateDao,
    required this.currentPubkey,
  });

  final AccountNotificationSyncStateDao syncStateDao;
  final String? currentPubkey;

  Future<DateTime?> getLastSyncTime() async {
    return syncStateDao.getLastSyncTime();
  }

  Future<DateTime?> getSyncState(ContentType contentType) async {
    final syncState = await syncStateDao.getByContentType(contentType: contentType);
    final timestamp = syncState?.sinceTimestamp;

    return timestamp?.toDateTime;
  }

  Future<void> updateSyncState(ContentType contentType, DateTime sinceTimestamp) async {
    final timestampInt = sinceTimestamp.microsecondsSinceEpoch;
    await syncStateDao.insertOrUpdate(
      contentType: contentType,
      lastSyncTimestamp: DateTime.now().microsecondsSinceEpoch,
      sinceTimestamp: timestampInt,
    );
  }
}
