// SPDX-License-Identifier: ice License 1.0

// dart format width=80
import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
final class Schema2 extends i0.VersionedSchema {
  Schema2({required super.database}) : super(version: 2);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    seenEventsTable,
    seenRepostsTable,
  ];
  late final Shape0 seenEventsTable = Shape0(
      source: i0.VersionedTable(
        entityName: 'seen_events_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(feed_type, feed_modifier, event_reference)',
        ],
        columns: [
          _column_0,
          _column_1,
          _column_2,
          _column_3,
          _column_4,
          _column_5,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 seenRepostsTable = Shape1(
      source: i0.VersionedTable(
        entityName: 'seen_reposts_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(reposted_event_reference)',
        ],
        columns: [
          _column_6,
          _column_7,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get feedType => columnsByName['feed_type']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get feedModifier =>
      columnsByName['feed_modifier']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get eventReference =>
      columnsByName['event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get nextEventReference =>
      columnsByName['next_event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get pubkey => columnsByName['pubkey']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get createdAt => columnsByName['created_at']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_0(String aliasedName) =>
    i1.GeneratedColumn<int>('feed_type', aliasedName, false, type: i1.DriftSqlType.int);
i1.GeneratedColumn<int> _column_1(String aliasedName) =>
    i1.GeneratedColumn<int>('feed_modifier', aliasedName, true, type: i1.DriftSqlType.int);
i1.GeneratedColumn<String> _column_2(String aliasedName) =>
    i1.GeneratedColumn<String>('event_reference', aliasedName, false, type: i1.DriftSqlType.string);
i1.GeneratedColumn<String> _column_3(String aliasedName) =>
    i1.GeneratedColumn<String>('next_event_reference', aliasedName, true,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<String> _column_4(String aliasedName) =>
    i1.GeneratedColumn<String>('pubkey', aliasedName, false, type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_5(String aliasedName) =>
    i1.GeneratedColumn<int>('created_at', aliasedName, false, type: i1.DriftSqlType.int);

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get repostedEventReference =>
      columnsByName['reposted_event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get seenAt => columnsByName['seen_at']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<String> _column_6(String aliasedName) =>
    i1.GeneratedColumn<String>('reposted_event_reference', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_7(String aliasedName) =>
    i1.GeneratedColumn<int>('seen_at', aliasedName, false, type: i1.DriftSqlType.int);
i0.MigrationStepWithVersion migrationSteps({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
}) {
  return (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = Schema2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
}) =>
    i0.VersionedSchema.stepByStepHelper(
        step: migrationSteps(
      from1To2: from1To2,
    ));
