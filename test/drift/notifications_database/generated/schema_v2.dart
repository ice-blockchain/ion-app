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

class LikesTable extends Table with TableInfo<LikesTable, LikesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LikesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> eventReference = GeneratedColumn<String>(
      'event_reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [eventReference, pubkey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'likes_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {eventReference, pubkey};
  @override
  LikesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LikesTableData(
      eventReference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_reference'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  LikesTable createAlias(String alias) {
    return LikesTable(attachedDatabase, alias);
  }
}

class LikesTableData extends DataClass implements Insertable<LikesTableData> {
  final String eventReference;
  final String pubkey;
  final DateTime createdAt;
  const LikesTableData(
      {required this.eventReference, required this.pubkey, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_reference'] = Variable<String>(eventReference);
    map['pubkey'] = Variable<String>(pubkey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LikesTableCompanion toCompanion(bool nullToAbsent) {
    return LikesTableCompanion(
      eventReference: Value(eventReference),
      pubkey: Value(pubkey),
      createdAt: Value(createdAt),
    );
  }

  factory LikesTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LikesTableData(
      eventReference: serializer.fromJson<String>(json['event_reference']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'event_reference': serializer.toJson<String>(eventReference),
      'pubkey': serializer.toJson<String>(pubkey),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  LikesTableData copyWith({String? eventReference, String? pubkey, DateTime? createdAt}) =>
      LikesTableData(
        eventReference: eventReference ?? this.eventReference,
        pubkey: pubkey ?? this.pubkey,
        createdAt: createdAt ?? this.createdAt,
      );
  LikesTableData copyWithCompanion(LikesTableCompanion data) {
    return LikesTableData(
      eventReference: data.eventReference.present ? data.eventReference.value : this.eventReference,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LikesTableData(')
          ..write('eventReference: $eventReference, ')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventReference, pubkey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikesTableData &&
          other.eventReference == this.eventReference &&
          other.pubkey == this.pubkey &&
          other.createdAt == this.createdAt);
}

class LikesTableCompanion extends UpdateCompanion<LikesTableData> {
  final Value<String> eventReference;
  final Value<String> pubkey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LikesTableCompanion({
    this.eventReference = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LikesTableCompanion.insert({
    required String eventReference,
    required String pubkey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : eventReference = Value(eventReference),
        pubkey = Value(pubkey),
        createdAt = Value(createdAt);
  static Insertable<LikesTableData> custom({
    Expression<String>? eventReference,
    Expression<String>? pubkey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventReference != null) 'event_reference': eventReference,
      if (pubkey != null) 'pubkey': pubkey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LikesTableCompanion copyWith(
      {Value<String>? eventReference,
      Value<String>? pubkey,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return LikesTableCompanion(
      eventReference: eventReference ?? this.eventReference,
      pubkey: pubkey ?? this.pubkey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventReference.present) {
      map['event_reference'] = Variable<String>(eventReference.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LikesTableCompanion(')
          ..write('eventReference: $eventReference, ')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FollowersTable extends Table with TableInfo<FollowersTable, FollowersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FollowersTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [pubkey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'followers_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {pubkey};
  @override
  FollowersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowersTableData(
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  FollowersTable createAlias(String alias) {
    return FollowersTable(attachedDatabase, alias);
  }
}

class FollowersTableData extends DataClass implements Insertable<FollowersTableData> {
  final String pubkey;
  final DateTime createdAt;
  const FollowersTableData({required this.pubkey, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pubkey'] = Variable<String>(pubkey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FollowersTableCompanion toCompanion(bool nullToAbsent) {
    return FollowersTableCompanion(
      pubkey: Value(pubkey),
      createdAt: Value(createdAt),
    );
  }

  factory FollowersTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowersTableData(
      pubkey: serializer.fromJson<String>(json['pubkey']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pubkey': serializer.toJson<String>(pubkey),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  FollowersTableData copyWith({String? pubkey, DateTime? createdAt}) => FollowersTableData(
        pubkey: pubkey ?? this.pubkey,
        createdAt: createdAt ?? this.createdAt,
      );
  FollowersTableData copyWithCompanion(FollowersTableCompanion data) {
    return FollowersTableData(
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowersTableData(')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pubkey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowersTableData &&
          other.pubkey == this.pubkey &&
          other.createdAt == this.createdAt);
}

class FollowersTableCompanion extends UpdateCompanion<FollowersTableData> {
  final Value<String> pubkey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FollowersTableCompanion({
    this.pubkey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowersTableCompanion.insert({
    required String pubkey,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : pubkey = Value(pubkey),
        createdAt = Value(createdAt);
  static Insertable<FollowersTableData> custom({
    Expression<String>? pubkey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pubkey != null) 'pubkey': pubkey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowersTableCompanion copyWith(
      {Value<String>? pubkey, Value<DateTime>? createdAt, Value<int>? rowid}) {
    return FollowersTableCompanion(
      pubkey: pubkey ?? this.pubkey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowersTableCompanion(')
          ..write('pubkey: $pubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final CommentsTable commentsTable = CommentsTable(this);
  late final LikesTable likesTable = LikesTable(this);
  late final FollowersTable followersTable = FollowersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [commentsTable, likesTable, followersTable];
  @override
  int get schemaVersion => 2;
}
