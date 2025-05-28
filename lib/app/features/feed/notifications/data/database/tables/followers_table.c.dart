// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';

@DataClassName('Follower')
class FollowersTable extends Table {
  TextColumn get pubkey => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {pubkey};
}
