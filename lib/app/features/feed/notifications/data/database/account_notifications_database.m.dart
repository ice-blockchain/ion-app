// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/account_notification_sync_state_table.d.dart';
import 'package:ion/app/features/user/data/database/tables/notification_user_relays_table.d.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifications_database.m.g.dart';

@riverpod
AccountNotificationsDatabase accountNotificationsDatabase(Ref ref) {
  keepAliveWhenAuthenticated(ref);

  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = AccountNotificationsDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(
  tables: [
    AccountNotificationSyncStateTable,
    NotificationUserRelaysTable,
  ],
)
class AccountNotificationsDatabase extends _$AccountNotificationsDatabase {
  AccountNotificationsDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'account_notifications_database_$pubkey');
  }
}
