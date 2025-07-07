// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/converters/feed_modifier_converter.d.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/converters/feed_type_converter.d.dart';

@DataClassName('FollowingUserFetchState')
class UserFetchStatesTable extends Table {
  IntColumn get feedType => integer().map(const FeedTypeConverter())();
  IntColumn get feedModifier => integer().map(const FeedModifierConverter())();
  TextColumn get pubkey => text()();
  IntColumn get emptyFetchCount => integer()();
  IntColumn get lastFetchTime => integer()();
  IntColumn get lastContentTime => integer().nullable()();

  @override
  Set<Column> get primaryKey => {feedType, feedModifier, pubkey};
}
