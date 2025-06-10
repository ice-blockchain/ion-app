// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/extensions/database.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.steps.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/followers_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/likes_table.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';

part 'notifications_database.c.g.dart';

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
              DATE(datetime(
                CASE 
                  WHEN LENGTH(created_at) > 13 THEN created_at / 1000000
                  ELSE created_at
                END, 'unixepoch', 'localtime')) AS event_date,
              event_reference,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(
                CASE 
                  WHEN LENGTH(created_at) > 13 THEN created_at / 1000000
                  ELSE created_at
                END, 'unixepoch', 'localtime')), event_reference 
                  ORDER BY created_at DESC) AS rn
          FROM
              likes_table
      )
      SELECT
          event_date,
          event_reference,
          MAX(created_at) AS last_created_at,
          GROUP_CONCAT(CASE WHEN rn <= 10 THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM
          DailyLikes
      GROUP BY
          event_date, event_reference
      ORDER BY
          last_created_at DESC, event_reference DESC;
    ''',
    'aggregatedFollowers': '''
      WITH DailyFollowers AS (
          SELECT
              DATE(datetime(
                CASE 
                  WHEN LENGTH(created_at) > 13 THEN created_at / 1000000
                  ELSE created_at
                END, 'unixepoch', 'localtime')) AS event_date,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(
                CASE 
                  WHEN LENGTH(created_at) > 13 THEN created_at / 1000000
                  ELSE created_at
                END, 'unixepoch', 'localtime')) 
                  ORDER BY created_at DESC) AS rn
          FROM
              followers_table
      )
      SELECT
          event_date,
          MAX(created_at) AS last_created_at,
          GROUP_CONCAT(CASE WHEN rn <= 10 THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM
          DailyFollowers
      GROUP BY
          event_date
      ORDER BY
          last_created_at DESC;
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
          await Future.wait(
            [
              m.alterTable(
                TableMigration(
                  schema.commentsTable,
                  columnTransformer: {
                    schema.commentsTable.createdAt: schema.commentsTable.normalizedTimestamp(
                      schema.commentsTable.createdAt,
                    ),
                  },
                ),
              ),
              m.alterTable(
                TableMigration(
                  schema.followersTable,
                  columnTransformer: {
                    schema.followersTable.createdAt: schema.followersTable.normalizedTimestamp(
                      schema.followersTable.createdAt,
                    ),
                  },
                ),
              ),
              m.alterTable(
                TableMigration(
                  schema.likesTable,
                  columnTransformer: {
                    schema.likesTable.createdAt: schema.likesTable.normalizedTimestamp(
                      schema.likesTable.createdAt,
                    ),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'notifications_database_$pubkey');
  }
}
