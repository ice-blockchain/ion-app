// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';

@DataClassName('SeenEvent')
class SeenEventsTable extends Table {
  IntColumn get feedType => intEnum<FeedType>()();
  IntColumn get feedModifier => intEnum<FeedModifier>().nullable()();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();
  TextColumn get nextEventReference => text().map(const EventReferenceConverter()).nullable()();
  TextColumn get pubkey => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {feedType, feedModifier, eventReference};
}
