// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class ConversationTable extends Table with TableInfo<ConversationTable, ConversationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> type = GeneratedColumn<int>('type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [id, type, joinedAt, isArchived, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  ConversationTable createAlias(String alias) {
    return ConversationTable(attachedDatabase, alias);
  }
}

class ConversationTableData extends DataClass implements Insertable<ConversationTableData> {
  final String id;
  final int type;
  final DateTime joinedAt;
  final bool isArchived;
  final bool isDeleted;
  const ConversationTableData(
      {required this.id,
      required this.type,
      required this.joinedAt,
      required this.isArchived,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<int>(type);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ConversationTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationTableCompanion(
      id: Value(id),
      type: Value(type),
      joinedAt: Value(joinedAt),
      isArchived: Value(isArchived),
      isDeleted: Value(isDeleted),
    );
  }

  factory ConversationTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      joinedAt: serializer.fromJson<DateTime>(json['joined_at']),
      isArchived: serializer.fromJson<bool>(json['is_archived']),
      isDeleted: serializer.fromJson<bool>(json['is_deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<int>(type),
      'joined_at': serializer.toJson<DateTime>(joinedAt),
      'is_archived': serializer.toJson<bool>(isArchived),
      'is_deleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ConversationTableData copyWith(
          {String? id, int? type, DateTime? joinedAt, bool? isArchived, bool? isDeleted}) =>
      ConversationTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        joinedAt: joinedAt ?? this.joinedAt,
        isArchived: isArchived ?? this.isArchived,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ConversationTableData copyWithCompanion(ConversationTableCompanion data) {
    return ConversationTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      isArchived: data.isArchived.present ? data.isArchived.value : this.isArchived,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, joinedAt, isArchived, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.joinedAt == this.joinedAt &&
          other.isArchived == this.isArchived &&
          other.isDeleted == this.isDeleted);
}

class ConversationTableCompanion extends UpdateCompanion<ConversationTableData> {
  final Value<String> id;
  final Value<int> type;
  final Value<DateTime> joinedAt;
  final Value<bool> isArchived;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ConversationTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationTableCompanion.insert({
    required String id,
    required int type,
    required DateTime joinedAt,
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        joinedAt = Value(joinedAt);
  static Insertable<ConversationTableData> custom({
    Expression<String>? id,
    Expression<int>? type,
    Expression<DateTime>? joinedAt,
    Expression<bool>? isArchived,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? type,
      Value<DateTime>? joinedAt,
      Value<bool>? isArchived,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ConversationTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      joinedAt: joinedAt ?? this.joinedAt,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class EventMessageTable extends Table with TableInfo<EventMessageTable, EventMessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EventMessageTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> kind = GeneratedColumn<int>('kind', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> sharedId = GeneratedColumn<String>(
      'shared_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> tags = GeneratedColumn<String>('tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> sig = GeneratedColumn<String>('sig', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, kind, sharedId, content, pubkey, tags, createdAt, sig];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_message_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventMessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventMessageTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      sharedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shared_id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      tags: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      sig: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sig']),
    );
  }

  @override
  EventMessageTable createAlias(String alias) {
    return EventMessageTable(attachedDatabase, alias);
  }
}

class EventMessageTableData extends DataClass implements Insertable<EventMessageTableData> {
  final String id;
  final int kind;
  final String? sharedId;
  final String content;
  final String pubkey;
  final String tags;
  final DateTime createdAt;
  final String? sig;
  const EventMessageTableData(
      {required this.id,
      required this.kind,
      this.sharedId,
      required this.content,
      required this.pubkey,
      required this.tags,
      required this.createdAt,
      this.sig});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<int>(kind);
    if (!nullToAbsent || sharedId != null) {
      map['shared_id'] = Variable<String>(sharedId);
    }
    map['content'] = Variable<String>(content);
    map['pubkey'] = Variable<String>(pubkey);
    map['tags'] = Variable<String>(tags);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sig != null) {
      map['sig'] = Variable<String>(sig);
    }
    return map;
  }

  EventMessageTableCompanion toCompanion(bool nullToAbsent) {
    return EventMessageTableCompanion(
      id: Value(id),
      kind: Value(kind),
      sharedId: sharedId == null && nullToAbsent ? const Value.absent() : Value(sharedId),
      content: Value(content),
      pubkey: Value(pubkey),
      tags: Value(tags),
      createdAt: Value(createdAt),
      sig: sig == null && nullToAbsent ? const Value.absent() : Value(sig),
    );
  }

  factory EventMessageTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventMessageTableData(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<int>(json['kind']),
      sharedId: serializer.fromJson<String?>(json['shared_id']),
      content: serializer.fromJson<String>(json['content']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      tags: serializer.fromJson<String>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      sig: serializer.fromJson<String?>(json['sig']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<int>(kind),
      'shared_id': serializer.toJson<String?>(sharedId),
      'content': serializer.toJson<String>(content),
      'pubkey': serializer.toJson<String>(pubkey),
      'tags': serializer.toJson<String>(tags),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'sig': serializer.toJson<String?>(sig),
    };
  }

  EventMessageTableData copyWith(
          {String? id,
          int? kind,
          Value<String?> sharedId = const Value.absent(),
          String? content,
          String? pubkey,
          String? tags,
          DateTime? createdAt,
          Value<String?> sig = const Value.absent()}) =>
      EventMessageTableData(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        sharedId: sharedId.present ? sharedId.value : this.sharedId,
        content: content ?? this.content,
        pubkey: pubkey ?? this.pubkey,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        sig: sig.present ? sig.value : this.sig,
      );
  EventMessageTableData copyWithCompanion(EventMessageTableCompanion data) {
    return EventMessageTableData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      sharedId: data.sharedId.present ? data.sharedId.value : this.sharedId,
      content: data.content.present ? data.content.value : this.content,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sig: data.sig.present ? data.sig.value : this.sig,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventMessageTableData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sharedId: $sharedId, ')
          ..write('content: $content, ')
          ..write('pubkey: $pubkey, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('sig: $sig')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, sharedId, content, pubkey, tags, createdAt, sig);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventMessageTableData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.sharedId == this.sharedId &&
          other.content == this.content &&
          other.pubkey == this.pubkey &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.sig == this.sig);
}

class EventMessageTableCompanion extends UpdateCompanion<EventMessageTableData> {
  final Value<String> id;
  final Value<int> kind;
  final Value<String?> sharedId;
  final Value<String> content;
  final Value<String> pubkey;
  final Value<String> tags;
  final Value<DateTime> createdAt;
  final Value<String?> sig;
  final Value<int> rowid;
  const EventMessageTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.sharedId = const Value.absent(),
    this.content = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sig = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventMessageTableCompanion.insert({
    required String id,
    required int kind,
    this.sharedId = const Value.absent(),
    required String content,
    required String pubkey,
    required String tags,
    required DateTime createdAt,
    this.sig = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        kind = Value(kind),
        content = Value(content),
        pubkey = Value(pubkey),
        tags = Value(tags),
        createdAt = Value(createdAt);
  static Insertable<EventMessageTableData> custom({
    Expression<String>? id,
    Expression<int>? kind,
    Expression<String>? sharedId,
    Expression<String>? content,
    Expression<String>? pubkey,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<String>? sig,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (sharedId != null) 'shared_id': sharedId,
      if (content != null) 'content': content,
      if (pubkey != null) 'pubkey': pubkey,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (sig != null) 'sig': sig,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventMessageTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? kind,
      Value<String?>? sharedId,
      Value<String>? content,
      Value<String>? pubkey,
      Value<String>? tags,
      Value<DateTime>? createdAt,
      Value<String?>? sig,
      Value<int>? rowid}) {
    return EventMessageTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      sharedId: sharedId ?? this.sharedId,
      content: content ?? this.content,
      pubkey: pubkey ?? this.pubkey,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      sig: sig ?? this.sig,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (sharedId.present) {
      map['shared_id'] = Variable<String>(sharedId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sig.present) {
      map['sig'] = Variable<String>(sig.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventMessageTableCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sharedId: $sharedId, ')
          ..write('content: $content, ')
          ..write('pubkey: $pubkey, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('sig: $sig, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ConversationMessageTable extends Table
    with TableInfo<ConversationMessageTable, ConversationMessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationMessageTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES conversation_table (id)'));
  late final GeneratedColumn<String> eventMessageId = GeneratedColumn<String>(
      'event_message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES event_message_table (id)'));
  late final GeneratedColumn<String> sharedId = GeneratedColumn<String>(
      'shared_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [conversationId, eventMessageId, sharedId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_message_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {eventMessageId};
  @override
  ConversationMessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationMessageTableData(
      conversationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      eventMessageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_message_id'])!,
      sharedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shared_id'])!,
    );
  }

  @override
  ConversationMessageTable createAlias(String alias) {
    return ConversationMessageTable(attachedDatabase, alias);
  }
}

class ConversationMessageTableData extends DataClass
    implements Insertable<ConversationMessageTableData> {
  final String conversationId;
  final String eventMessageId;
  final String sharedId;
  const ConversationMessageTableData(
      {required this.conversationId, required this.eventMessageId, required this.sharedId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['event_message_id'] = Variable<String>(eventMessageId);
    map['shared_id'] = Variable<String>(sharedId);
    return map;
  }

  ConversationMessageTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationMessageTableCompanion(
      conversationId: Value(conversationId),
      eventMessageId: Value(eventMessageId),
      sharedId: Value(sharedId),
    );
  }

  factory ConversationMessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationMessageTableData(
      conversationId: serializer.fromJson<String>(json['conversation_id']),
      eventMessageId: serializer.fromJson<String>(json['event_message_id']),
      sharedId: serializer.fromJson<String>(json['shared_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversation_id': serializer.toJson<String>(conversationId),
      'event_message_id': serializer.toJson<String>(eventMessageId),
      'shared_id': serializer.toJson<String>(sharedId),
    };
  }

  ConversationMessageTableData copyWith(
          {String? conversationId, String? eventMessageId, String? sharedId}) =>
      ConversationMessageTableData(
        conversationId: conversationId ?? this.conversationId,
        eventMessageId: eventMessageId ?? this.eventMessageId,
        sharedId: sharedId ?? this.sharedId,
      );
  ConversationMessageTableData copyWithCompanion(ConversationMessageTableCompanion data) {
    return ConversationMessageTableData(
      conversationId: data.conversationId.present ? data.conversationId.value : this.conversationId,
      eventMessageId: data.eventMessageId.present ? data.eventMessageId.value : this.eventMessageId,
      sharedId: data.sharedId.present ? data.sharedId.value : this.sharedId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMessageTableData(')
          ..write('conversationId: $conversationId, ')
          ..write('eventMessageId: $eventMessageId, ')
          ..write('sharedId: $sharedId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(conversationId, eventMessageId, sharedId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationMessageTableData &&
          other.conversationId == this.conversationId &&
          other.eventMessageId == this.eventMessageId &&
          other.sharedId == this.sharedId);
}

class ConversationMessageTableCompanion extends UpdateCompanion<ConversationMessageTableData> {
  final Value<String> conversationId;
  final Value<String> eventMessageId;
  final Value<String> sharedId;
  final Value<int> rowid;
  const ConversationMessageTableCompanion({
    this.conversationId = const Value.absent(),
    this.eventMessageId = const Value.absent(),
    this.sharedId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationMessageTableCompanion.insert({
    required String conversationId,
    required String eventMessageId,
    required String sharedId,
    this.rowid = const Value.absent(),
  })  : conversationId = Value(conversationId),
        eventMessageId = Value(eventMessageId),
        sharedId = Value(sharedId);
  static Insertable<ConversationMessageTableData> custom({
    Expression<String>? conversationId,
    Expression<String>? eventMessageId,
    Expression<String>? sharedId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (eventMessageId != null) 'event_message_id': eventMessageId,
      if (sharedId != null) 'shared_id': sharedId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationMessageTableCompanion copyWith(
      {Value<String>? conversationId,
      Value<String>? eventMessageId,
      Value<String>? sharedId,
      Value<int>? rowid}) {
    return ConversationMessageTableCompanion(
      conversationId: conversationId ?? this.conversationId,
      eventMessageId: eventMessageId ?? this.eventMessageId,
      sharedId: sharedId ?? this.sharedId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (eventMessageId.present) {
      map['event_message_id'] = Variable<String>(eventMessageId.value);
    }
    if (sharedId.present) {
      map['shared_id'] = Variable<String>(sharedId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMessageTableCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('eventMessageId: $eventMessageId, ')
          ..write('sharedId: $sharedId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MessageStatusTable extends Table with TableInfo<MessageStatusTable, MessageStatusTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessageStatusTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> sharedId = GeneratedColumn<String>(
      'shared_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> masterPubkey = GeneratedColumn<String>(
      'master_pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> status = GeneratedColumn<int>('status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sharedId, pubkey, masterPubkey, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_status_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageStatusTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageStatusTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sharedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shared_id'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      masterPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}master_pubkey'])!,
      status:
          attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!,
    );
  }

  @override
  MessageStatusTable createAlias(String alias) {
    return MessageStatusTable(attachedDatabase, alias);
  }
}

class MessageStatusTableData extends DataClass implements Insertable<MessageStatusTableData> {
  final int id;
  final String sharedId;
  final String pubkey;
  final String masterPubkey;
  final int status;
  const MessageStatusTableData(
      {required this.id,
      required this.sharedId,
      required this.pubkey,
      required this.masterPubkey,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shared_id'] = Variable<String>(sharedId);
    map['pubkey'] = Variable<String>(pubkey);
    map['master_pubkey'] = Variable<String>(masterPubkey);
    map['status'] = Variable<int>(status);
    return map;
  }

  MessageStatusTableCompanion toCompanion(bool nullToAbsent) {
    return MessageStatusTableCompanion(
      id: Value(id),
      sharedId: Value(sharedId),
      pubkey: Value(pubkey),
      masterPubkey: Value(masterPubkey),
      status: Value(status),
    );
  }

  factory MessageStatusTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageStatusTableData(
      id: serializer.fromJson<int>(json['id']),
      sharedId: serializer.fromJson<String>(json['shared_id']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      masterPubkey: serializer.fromJson<String>(json['master_pubkey']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shared_id': serializer.toJson<String>(sharedId),
      'pubkey': serializer.toJson<String>(pubkey),
      'master_pubkey': serializer.toJson<String>(masterPubkey),
      'status': serializer.toJson<int>(status),
    };
  }

  MessageStatusTableData copyWith(
          {int? id, String? sharedId, String? pubkey, String? masterPubkey, int? status}) =>
      MessageStatusTableData(
        id: id ?? this.id,
        sharedId: sharedId ?? this.sharedId,
        pubkey: pubkey ?? this.pubkey,
        masterPubkey: masterPubkey ?? this.masterPubkey,
        status: status ?? this.status,
      );
  MessageStatusTableData copyWithCompanion(MessageStatusTableCompanion data) {
    return MessageStatusTableData(
      id: data.id.present ? data.id.value : this.id,
      sharedId: data.sharedId.present ? data.sharedId.value : this.sharedId,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      masterPubkey: data.masterPubkey.present ? data.masterPubkey.value : this.masterPubkey,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageStatusTableData(')
          ..write('id: $id, ')
          ..write('sharedId: $sharedId, ')
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sharedId, pubkey, masterPubkey, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageStatusTableData &&
          other.id == this.id &&
          other.sharedId == this.sharedId &&
          other.pubkey == this.pubkey &&
          other.masterPubkey == this.masterPubkey &&
          other.status == this.status);
}

class MessageStatusTableCompanion extends UpdateCompanion<MessageStatusTableData> {
  final Value<int> id;
  final Value<String> sharedId;
  final Value<String> pubkey;
  final Value<String> masterPubkey;
  final Value<int> status;
  const MessageStatusTableCompanion({
    this.id = const Value.absent(),
    this.sharedId = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.masterPubkey = const Value.absent(),
    this.status = const Value.absent(),
  });
  MessageStatusTableCompanion.insert({
    this.id = const Value.absent(),
    required String sharedId,
    required String pubkey,
    required String masterPubkey,
    required int status,
  })  : sharedId = Value(sharedId),
        pubkey = Value(pubkey),
        masterPubkey = Value(masterPubkey),
        status = Value(status);
  static Insertable<MessageStatusTableData> custom({
    Expression<int>? id,
    Expression<String>? sharedId,
    Expression<String>? pubkey,
    Expression<String>? masterPubkey,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sharedId != null) 'shared_id': sharedId,
      if (pubkey != null) 'pubkey': pubkey,
      if (masterPubkey != null) 'master_pubkey': masterPubkey,
      if (status != null) 'status': status,
    });
  }

  MessageStatusTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? sharedId,
      Value<String>? pubkey,
      Value<String>? masterPubkey,
      Value<int>? status}) {
    return MessageStatusTableCompanion(
      id: id ?? this.id,
      sharedId: sharedId ?? this.sharedId,
      pubkey: pubkey ?? this.pubkey,
      masterPubkey: masterPubkey ?? this.masterPubkey,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sharedId.present) {
      map['shared_id'] = Variable<String>(sharedId.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (masterPubkey.present) {
      map['master_pubkey'] = Variable<String>(masterPubkey.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageStatusTableCompanion(')
          ..write('id: $id, ')
          ..write('sharedId: $sharedId, ')
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class ReactionTable extends Table with TableInfo<ReactionTable, ReactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ReactionTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES event_message_table (id)'));
  late final GeneratedColumn<String> kind14SharedId = GeneratedColumn<String>(
      'kind14_shared_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES event_message_table (shared_id)'));
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> masterPubkey = GeneratedColumn<String>(
      'master_pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [id, kind14SharedId, content, masterPubkey, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reaction_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ReactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReactionTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind14SharedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind14_shared_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      masterPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}master_pubkey'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  ReactionTable createAlias(String alias) {
    return ReactionTable(attachedDatabase, alias);
  }
}

class ReactionTableData extends DataClass implements Insertable<ReactionTableData> {
  final String id;
  final String kind14SharedId;
  final String content;
  final String masterPubkey;
  final bool isDeleted;
  const ReactionTableData(
      {required this.id,
      required this.kind14SharedId,
      required this.content,
      required this.masterPubkey,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind14_shared_id'] = Variable<String>(kind14SharedId);
    map['content'] = Variable<String>(content);
    map['master_pubkey'] = Variable<String>(masterPubkey);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ReactionTableCompanion toCompanion(bool nullToAbsent) {
    return ReactionTableCompanion(
      id: Value(id),
      kind14SharedId: Value(kind14SharedId),
      content: Value(content),
      masterPubkey: Value(masterPubkey),
      isDeleted: Value(isDeleted),
    );
  }

  factory ReactionTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReactionTableData(
      id: serializer.fromJson<String>(json['id']),
      kind14SharedId: serializer.fromJson<String>(json['kind14_shared_id']),
      content: serializer.fromJson<String>(json['content']),
      masterPubkey: serializer.fromJson<String>(json['master_pubkey']),
      isDeleted: serializer.fromJson<bool>(json['is_deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind14_shared_id': serializer.toJson<String>(kind14SharedId),
      'content': serializer.toJson<String>(content),
      'master_pubkey': serializer.toJson<String>(masterPubkey),
      'is_deleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ReactionTableData copyWith(
          {String? id,
          String? kind14SharedId,
          String? content,
          String? masterPubkey,
          bool? isDeleted}) =>
      ReactionTableData(
        id: id ?? this.id,
        kind14SharedId: kind14SharedId ?? this.kind14SharedId,
        content: content ?? this.content,
        masterPubkey: masterPubkey ?? this.masterPubkey,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ReactionTableData copyWithCompanion(ReactionTableCompanion data) {
    return ReactionTableData(
      id: data.id.present ? data.id.value : this.id,
      kind14SharedId: data.kind14SharedId.present ? data.kind14SharedId.value : this.kind14SharedId,
      content: data.content.present ? data.content.value : this.content,
      masterPubkey: data.masterPubkey.present ? data.masterPubkey.value : this.masterPubkey,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReactionTableData(')
          ..write('id: $id, ')
          ..write('kind14SharedId: $kind14SharedId, ')
          ..write('content: $content, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind14SharedId, content, masterPubkey, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReactionTableData &&
          other.id == this.id &&
          other.kind14SharedId == this.kind14SharedId &&
          other.content == this.content &&
          other.masterPubkey == this.masterPubkey &&
          other.isDeleted == this.isDeleted);
}

class ReactionTableCompanion extends UpdateCompanion<ReactionTableData> {
  final Value<String> id;
  final Value<String> kind14SharedId;
  final Value<String> content;
  final Value<String> masterPubkey;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ReactionTableCompanion({
    this.id = const Value.absent(),
    this.kind14SharedId = const Value.absent(),
    this.content = const Value.absent(),
    this.masterPubkey = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionTableCompanion.insert({
    required String id,
    required String kind14SharedId,
    required String content,
    required String masterPubkey,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        kind14SharedId = Value(kind14SharedId),
        content = Value(content),
        masterPubkey = Value(masterPubkey);
  static Insertable<ReactionTableData> custom({
    Expression<String>? id,
    Expression<String>? kind14SharedId,
    Expression<String>? content,
    Expression<String>? masterPubkey,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind14SharedId != null) 'kind14_shared_id': kind14SharedId,
      if (content != null) 'content': content,
      if (masterPubkey != null) 'master_pubkey': masterPubkey,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? kind14SharedId,
      Value<String>? content,
      Value<String>? masterPubkey,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ReactionTableCompanion(
      id: id ?? this.id,
      kind14SharedId: kind14SharedId ?? this.kind14SharedId,
      content: content ?? this.content,
      masterPubkey: masterPubkey ?? this.masterPubkey,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind14SharedId.present) {
      map['kind14_shared_id'] = Variable<String>(kind14SharedId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (masterPubkey.present) {
      map['master_pubkey'] = Variable<String>(masterPubkey.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReactionTableCompanion(')
          ..write('id: $id, ')
          ..write('kind14SharedId: $kind14SharedId, ')
          ..write('content: $content, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MessageMediaTable extends Table with TableInfo<MessageMediaTable, MessageMediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessageMediaTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> status = GeneratedColumn<int>('status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
      'remote_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> eventMessageId = GeneratedColumn<String>(
      'event_message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES event_message_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, status, remoteUrl, cacheKey, eventMessageId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_media_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageMediaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageMediaTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      status:
          attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      remoteUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_url']),
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key']),
      eventMessageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_message_id'])!,
    );
  }

  @override
  MessageMediaTable createAlias(String alias) {
    return MessageMediaTable(attachedDatabase, alias);
  }
}

class MessageMediaTableData extends DataClass implements Insertable<MessageMediaTableData> {
  final int id;
  final int status;
  final String? remoteUrl;
  final String? cacheKey;
  final String eventMessageId;
  const MessageMediaTableData(
      {required this.id,
      required this.status,
      this.remoteUrl,
      this.cacheKey,
      required this.eventMessageId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || remoteUrl != null) {
      map['remote_url'] = Variable<String>(remoteUrl);
    }
    if (!nullToAbsent || cacheKey != null) {
      map['cache_key'] = Variable<String>(cacheKey);
    }
    map['event_message_id'] = Variable<String>(eventMessageId);
    return map;
  }

  MessageMediaTableCompanion toCompanion(bool nullToAbsent) {
    return MessageMediaTableCompanion(
      id: Value(id),
      status: Value(status),
      remoteUrl: remoteUrl == null && nullToAbsent ? const Value.absent() : Value(remoteUrl),
      cacheKey: cacheKey == null && nullToAbsent ? const Value.absent() : Value(cacheKey),
      eventMessageId: Value(eventMessageId),
    );
  }

  factory MessageMediaTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageMediaTableData(
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<int>(json['status']),
      remoteUrl: serializer.fromJson<String?>(json['remote_url']),
      cacheKey: serializer.fromJson<String?>(json['cache_key']),
      eventMessageId: serializer.fromJson<String>(json['event_message_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'status': serializer.toJson<int>(status),
      'remote_url': serializer.toJson<String?>(remoteUrl),
      'cache_key': serializer.toJson<String?>(cacheKey),
      'event_message_id': serializer.toJson<String>(eventMessageId),
    };
  }

  MessageMediaTableData copyWith(
          {int? id,
          int? status,
          Value<String?> remoteUrl = const Value.absent(),
          Value<String?> cacheKey = const Value.absent(),
          String? eventMessageId}) =>
      MessageMediaTableData(
        id: id ?? this.id,
        status: status ?? this.status,
        remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
        cacheKey: cacheKey.present ? cacheKey.value : this.cacheKey,
        eventMessageId: eventMessageId ?? this.eventMessageId,
      );
  MessageMediaTableData copyWithCompanion(MessageMediaTableCompanion data) {
    return MessageMediaTableData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      eventMessageId: data.eventMessageId.present ? data.eventMessageId.value : this.eventMessageId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageMediaTableData(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('eventMessageId: $eventMessageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, status, remoteUrl, cacheKey, eventMessageId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageMediaTableData &&
          other.id == this.id &&
          other.status == this.status &&
          other.remoteUrl == this.remoteUrl &&
          other.cacheKey == this.cacheKey &&
          other.eventMessageId == this.eventMessageId);
}

class MessageMediaTableCompanion extends UpdateCompanion<MessageMediaTableData> {
  final Value<int> id;
  final Value<int> status;
  final Value<String?> remoteUrl;
  final Value<String?> cacheKey;
  final Value<String> eventMessageId;
  const MessageMediaTableCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.cacheKey = const Value.absent(),
    this.eventMessageId = const Value.absent(),
  });
  MessageMediaTableCompanion.insert({
    this.id = const Value.absent(),
    required int status,
    this.remoteUrl = const Value.absent(),
    this.cacheKey = const Value.absent(),
    required String eventMessageId,
  })  : status = Value(status),
        eventMessageId = Value(eventMessageId);
  static Insertable<MessageMediaTableData> custom({
    Expression<int>? id,
    Expression<int>? status,
    Expression<String>? remoteUrl,
    Expression<String>? cacheKey,
    Expression<String>? eventMessageId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (cacheKey != null) 'cache_key': cacheKey,
      if (eventMessageId != null) 'event_message_id': eventMessageId,
    });
  }

  MessageMediaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? status,
      Value<String?>? remoteUrl,
      Value<String?>? cacheKey,
      Value<String>? eventMessageId}) {
    return MessageMediaTableCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      cacheKey: cacheKey ?? this.cacheKey,
      eventMessageId: eventMessageId ?? this.eventMessageId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (remoteUrl.present) {
      map['remote_url'] = Variable<String>(remoteUrl.value);
    }
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (eventMessageId.present) {
      map['event_message_id'] = Variable<String>(eventMessageId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageMediaTableCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('eventMessageId: $eventMessageId')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV6 extends GeneratedDatabase {
  DatabaseAtV6(QueryExecutor e) : super(e);
  late final ConversationTable conversationTable = ConversationTable(this);
  late final EventMessageTable eventMessageTable = EventMessageTable(this);
  late final ConversationMessageTable conversationMessageTable = ConversationMessageTable(this);
  late final MessageStatusTable messageStatusTable = MessageStatusTable(this);
  late final ReactionTable reactionTable = ReactionTable(this);
  late final MessageMediaTable messageMediaTable = MessageMediaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        conversationTable,
        eventMessageTable,
        conversationMessageTable,
        messageStatusTable,
        reactionTable,
        messageMediaTable
      ];
  @override
  int get schemaVersion => 6;
}
