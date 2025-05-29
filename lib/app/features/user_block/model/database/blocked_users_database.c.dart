// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/database.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user_block/extensions/event_message.dart';
import 'package:ion/app/features/user_block/model/database/blocked_users_database.c.steps.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/providers/blocked_users_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_database.c.g.dart';
part 'dao/block_event_dao.c.dart';
part 'tables/block_event_table.dart';
part 'tables/deleted_block_event_table.dart';

@DriftDatabase(
  tables: [
    BlockEventTable,
    DeletedBlockEventTable,
  ],
  daos: [BlockEventDao],
)
class BlockedUsersDatabase extends _$BlockedUsersDatabase {
  BlockedUsersDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'blocked_users_database_$pubkey');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.alterTable(
            TableMigration(
              schema.blockEventTable,
              columnTransformer: {
                schema.blockEventTable.createdAt: schema.blockEventTable.normalizedTimestamp(
                  schema.blockEventTable.createdAt,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
