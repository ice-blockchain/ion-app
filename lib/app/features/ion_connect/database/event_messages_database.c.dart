// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/database.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/database/event_messages_database.c.steps.dart';
import 'package:ion/app/features/ion_connect/database/tables/event_messages_table.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_messages_database.c.g.dart';

@Riverpod(keepAlive: true)
EventMessagesDatabase eventMessagesDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = EventMessagesDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(tables: [EventMessagesTable])
class EventMessagesDatabase extends _$EventMessagesDatabase {
  EventMessagesDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migration) => migration.createAll(),
        onUpgrade: stepByStep(
          from1To2: (m, schema) {
            return m.alterTable(TableMigration(schema.eventMessagesTable));
          },
          from2To3: (m, schema) {
            return m.alterTable(
              TableMigration(
                schema.eventMessagesTable,
                columnTransformer: {
                  schema.eventMessagesTable.createdAt:
                      schema.eventMessagesTable.normalizedTimestamp(
                    schema.eventMessagesTable.createdAt,
                  ),
                },
              ),
            );
          },
        ),
      );

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'event_messages_database_$pubkey');
  }
}
