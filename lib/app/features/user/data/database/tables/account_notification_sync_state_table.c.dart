// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('AccountNotificationSyncState')
class AccountNotificationSyncStateTable extends Table {
  /// Relay URL
  TextColumn get relayUrl => text()();

  /// Content type (posts, stories, articles, videos)
  TextColumn get contentType => text()();

  /// Last sync timestamp in microseconds since epoch
  IntColumn get lastSyncTimestamp => integer()();

  /// The 'since' timestamp for the next sync (last known event timestamp)
  IntColumn get sinceTimestamp => integer().nullable()();

  @override
  Set<Column> get primaryKey => {relayUrl, contentType};
}
