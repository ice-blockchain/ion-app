// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.steps.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/followers_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/likes_table.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_database.c.g.dart';

@Riverpod(keepAlive: true)
NotificationsDatabase notificationsDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = NotificationsDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(
  tables: [
    CommentsTable,
    LikesTable,
    FollowersTable,
  ],
  queries: {
    'aggregatedLikes': '''
      WITH DailyLikes AS (
          SELECT
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS event_date,
              event_reference,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')), event_reference 
                  ORDER BY created_at DESC) AS rn
          FROM
              likes_table
      )
      SELECT
          event_date,
          event_reference,
          GROUP_CONCAT(CASE WHEN rn <= 10 THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM
          DailyLikes
      GROUP BY
          event_date, event_reference
      ORDER BY
          event_date DESC, event_reference DESC;
    ''',
    'aggregatedFollowers': '''
      WITH DailyFollowers AS (
          SELECT
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS event_date,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')) 
                  ORDER BY created_at DESC) AS rn
          FROM
              followers_table
      )
      SELECT
          event_date,
          GROUP_CONCAT(CASE WHEN rn <= 10 THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM
          DailyFollowers
      GROUP BY
          event_date
      ORDER BY
          event_date DESC;
    ''',
  },
)
class NotificationsDatabase extends _$NotificationsDatabase {
  NotificationsDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await Future.wait([
            m.createTable(schema.followersTable),
            m.createTable(schema.likesTable),
          ]);
        },
        from2To3: (m, schema) async {
          await Future.wait([
            m.alterTable(
              TableMigration(
                schema.commentsTable,
                columnTransformer: {
                  schema.commentsTable.createdAt: schema.commentsTable.createdAt.cast<int>(),
                },
              ),
            ),
            m.alterTable(
              TableMigration(
                schema.followersTable,
                columnTransformer: {
                  schema.followersTable.createdAt: schema.followersTable.createdAt.cast<int>(),
                },
              ),
            ),
            m.alterTable(
              TableMigration(
                schema.likesTable,
                columnTransformer: {
                  schema.likesTable.createdAt: schema.likesTable.createdAt.cast<int>(),
                },
              ),
            ),
          ]);
        },
      ),
    );
  }

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'notifications_database_$pubkey');
  }
}
