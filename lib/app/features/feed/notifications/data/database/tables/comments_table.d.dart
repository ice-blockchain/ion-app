// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';

@DataClassName('Comment')
class CommentsTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();
  IntColumn get createdAt => integer()();
  IntColumn get type => intEnum<CommentType>()();

  @override
  Set<Column> get primaryKey => {eventReference};
}

// Caution! Add new values only to the end
// https://drift.simonbinder.eu/type_converters/#implicit-enum-converters
enum CommentType {
  reply,
  repost,
  quote,
}
