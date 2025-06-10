// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';

@DataClassName('Like')
class LikesTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();
  TextColumn get pubkey => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {eventReference, pubkey};
}
