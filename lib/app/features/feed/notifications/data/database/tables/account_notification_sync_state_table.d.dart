// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/notifications/data/model/content_type.dart';

@DataClassName('AccountNotificationSyncState')
class AccountNotificationSyncStateTable extends Table {
  /// Content type (posts, stories, articles, videos)
  IntColumn get contentType => intEnum<ContentType>()();

  /// Last sync timestamp in microseconds since epoch
  IntColumn get lastSyncTimestamp => integer()();

  /// The 'since' timestamp for the next sync (last known event timestamp)
  IntColumn get sinceTimestamp => integer().nullable()();

  @override
  Set<Column> get primaryKey => {contentType};
}
