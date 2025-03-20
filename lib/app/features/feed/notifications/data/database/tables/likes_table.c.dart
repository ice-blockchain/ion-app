// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';

@DataClassName('Like')
class LikesTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();
  TextColumn get pubkey => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {eventReference, pubkey};
}
