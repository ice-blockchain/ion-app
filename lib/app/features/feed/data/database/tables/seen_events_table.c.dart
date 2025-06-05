// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/database/converters/feed_modifier_converter.c.dart';
import 'package:ion/app/features/feed/data/database/converters/feed_type_converter.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';

@DataClassName('SeenEvent')
class SeenEventsTable extends Table {
  IntColumn get feedType => integer().map(const FeedTypeConverter())();
  IntColumn get feedModifier => integer().map(const FeedModifierConverter())();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();
  TextColumn get nextEventReference => text().map(const EventReferenceConverter()).nullable()();
  TextColumn get pubkey => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {feedType, feedModifier, eventReference};
}
