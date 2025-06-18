// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('NotificationUserRelays')
class NotificationUserRelaysTable extends Table {
  /// User's master pubkey
  TextColumn get userPubkey => text()();

  /// JSON array of relay URLs for this user
  TextColumn get relayUrls => text()();

  /// When the relay list was cached
  IntColumn get cachedAt => integer()();

  @override
  Set<Column> get primaryKey => {userPubkey};
}
