// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user_block/extensions/event_message.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/providers/blocked_users_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_user_database.c.g.dart';
part 'dao/block_event_dao.c.dart';
part 'dao/unblock_event_dao.c.dart';
part 'tables/block_event_table.dart';
part 'tables/unblock_event_table.dart';

@DriftDatabase(
  tables: [
    BlockEventTable,
    UnblockEventTable,
  ],
  daos: [BlockEventDao],
)
class BlockUserDatabase extends _$BlockUserDatabase {
  BlockUserDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'block_user_database_$pubkey');
  }
}
