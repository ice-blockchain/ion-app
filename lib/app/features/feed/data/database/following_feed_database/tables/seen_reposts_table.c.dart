// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';

@DataClassName('SeenRepost')
class SeenRepostsTable extends Table {
  TextColumn get repostedEventReference => text().map(const EventReferenceConverter())();
  IntColumn get seenAt => integer()();

  @override
  Set<Column> get primaryKey => {repostedEventReference};
}
