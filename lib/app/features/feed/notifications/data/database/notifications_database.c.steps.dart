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
    commentsTable,
    likesTable,
    followersTable,
  ];
  late final Shape0 commentsTable = Shape0(
      source: i0.VersionedTable(
        entityName: 'comments_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(event_reference)',
        ],
        columns: [
          _column_0,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 likesTable = Shape1(
      source: i0.VersionedTable(
        entityName: 'likes_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(event_reference, pubkey)',
        ],
        columns: [
          _column_0,
          _column_3,
          _column_1,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape2 followersTable = Shape2(
      source: i0.VersionedTable(
        entityName: 'followers_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(pubkey)',
        ],
        columns: [
          _column_3,
          _column_1,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get eventReference =>
      columnsByName['event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<int> get type => columnsByName['type']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<String> _column_0(String aliasedName) =>
    i1.GeneratedColumn<String>('event_reference', aliasedName, false, type: i1.DriftSqlType.string);
i1.GeneratedColumn<DateTime> _column_1(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('created_at', aliasedName, false, type: i1.DriftSqlType.dateTime);
i1.GeneratedColumn<int> _column_2(String aliasedName) =>
    i1.GeneratedColumn<int>('type', aliasedName, false, type: i1.DriftSqlType.int);

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get eventReference =>
      columnsByName['event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get pubkey => columnsByName['pubkey']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<String> _column_3(String aliasedName) =>
    i1.GeneratedColumn<String>('pubkey', aliasedName, false, type: i1.DriftSqlType.string);

class Shape2 extends i0.VersionedTable {
  Shape2({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get pubkey => columnsByName['pubkey']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get createdAt =>
      columnsByName['created_at']! as i1.GeneratedColumn<DateTime>;
}

final class Schema3 extends i0.VersionedSchema {
  Schema3({required super.database}) : super(version: 3);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    commentsTable,
    likesTable,
    followersTable,
  ];
  late final Shape3 commentsTable = Shape3(
      source: i0.VersionedTable(
        entityName: 'comments_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(event_reference)',
        ],
        columns: [
          _column_0,
          _column_4,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape4 likesTable = Shape4(
      source: i0.VersionedTable(
        entityName: 'likes_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(event_reference, pubkey)',
        ],
        columns: [
          _column_0,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape5 followersTable = Shape5(
      source: i0.VersionedTable(
        entityName: 'followers_table',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [
          'PRIMARY KEY(pubkey)',
        ],
        columns: [
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape3 extends i0.VersionedTable {
  Shape3({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get eventReference =>
      columnsByName['event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get createdAt => columnsByName['created_at']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get type => columnsByName['type']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_4(String aliasedName) =>
    i1.GeneratedColumn<int>('created_at', aliasedName, false, type: i1.DriftSqlType.int);

class Shape4 extends i0.VersionedTable {
  Shape4({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get eventReference =>
      columnsByName['event_reference']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get pubkey => columnsByName['pubkey']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get createdAt => columnsByName['created_at']! as i1.GeneratedColumn<int>;
}

class Shape5 extends i0.VersionedTable {
  Shape5({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<String> get pubkey => columnsByName['pubkey']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get createdAt => columnsByName['created_at']! as i1.GeneratedColumn<int>;
}

i0.MigrationStepWithVersion migrationSteps({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
}) {
  return (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = Schema2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      case 2:
        final schema = Schema3(database: database);
        final migrator = i1.Migrator(database, schema);
        await from2To3(migrator, schema);
        return 3;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
}) =>
    i0.VersionedSchema.stepByStepHelper(
        step: migrationSteps(
      from1To2: from1To2,
      from2To3: from2To3,
    ));
