// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

enum ContentType {
  posts(0),
  stories(1),
  articles(2),
  videos(3);

  const ContentType(this.value);
  final int value;

  static ContentType fromValue(int value) {
    return ContentType.values.firstWhere((type) => type.value == value);
  }
}

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
