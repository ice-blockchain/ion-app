// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('Comment')
class CommentsTable extends Table {
  late final eventReference = text()();
  late final createdAt = dateTime()();

  @override
  Set<Column> get primaryKey => {eventReference};
}
