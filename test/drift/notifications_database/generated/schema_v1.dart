// SPDX-License-Identifier: ice License 1.0

// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class CommentsTable extends Table with TableInfo<CommentsTable, CommentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CommentsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> eventReference = GeneratedColumn<String>(
      'event_reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<int> type = GeneratedColumn<int>('type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [eventReference, createdAt, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comments_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {eventReference};
  @override
  CommentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommentsTableData(
      eventReference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_reference'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}type'])!,
    );
  }

  @override
  CommentsTable createAlias(String alias) {
    return CommentsTable(attachedDatabase, alias);
  }
}

class CommentsTableData extends DataClass implements Insertable<CommentsTableData> {
  final String eventReference;
  final DateTime createdAt;
  final int type;
  const CommentsTableData(
      {required this.eventReference, required this.createdAt, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_reference'] = Variable<String>(eventReference);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['type'] = Variable<int>(type);
    return map;
  }

  CommentsTableCompanion toCompanion(bool nullToAbsent) {
    return CommentsTableCompanion(
      eventReference: Value(eventReference),
      createdAt: Value(createdAt),
      type: Value(type),
    );
  }

  factory CommentsTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommentsTableData(
      eventReference: serializer.fromJson<String>(json['event_reference']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'event_reference': serializer.toJson<String>(eventReference),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'type': serializer.toJson<int>(type),
    };
  }

  CommentsTableData copyWith({String? eventReference, DateTime? createdAt, int? type}) =>
      CommentsTableData(
        eventReference: eventReference ?? this.eventReference,
        createdAt: createdAt ?? this.createdAt,
        type: type ?? this.type,
      );
  CommentsTableData copyWithCompanion(CommentsTableCompanion data) {
    return CommentsTableData(
      eventReference: data.eventReference.present ? data.eventReference.value : this.eventReference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommentsTableData(')
          ..write('eventReference: $eventReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventReference, createdAt, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentsTableData &&
          other.eventReference == this.eventReference &&
          other.createdAt == this.createdAt &&
          other.type == this.type);
}

class CommentsTableCompanion extends UpdateCompanion<CommentsTableData> {
  final Value<String> eventReference;
  final Value<DateTime> createdAt;
  final Value<int> type;
  final Value<int> rowid;
  const CommentsTableCompanion({
    this.eventReference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentsTableCompanion.insert({
    required String eventReference,
    required DateTime createdAt,
    required int type,
    this.rowid = const Value.absent(),
  })  : eventReference = Value(eventReference),
        createdAt = Value(createdAt),
        type = Value(type);
  static Insertable<CommentsTableData> custom({
    Expression<String>? eventReference,
    Expression<DateTime>? createdAt,
    Expression<int>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventReference != null) 'event_reference': eventReference,
      if (createdAt != null) 'created_at': createdAt,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentsTableCompanion copyWith(
      {Value<String>? eventReference,
      Value<DateTime>? createdAt,
      Value<int>? type,
      Value<int>? rowid}) {
    return CommentsTableCompanion(
      eventReference: eventReference ?? this.eventReference,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventReference.present) {
      map['event_reference'] = Variable<String>(eventReference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentsTableCompanion(')
          ..write('eventReference: $eventReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final CommentsTable commentsTable = CommentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [commentsTable];
  @override
  int get schemaVersion => 1;
}
