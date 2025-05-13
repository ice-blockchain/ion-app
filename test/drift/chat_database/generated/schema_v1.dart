// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class ConversationTable extends Table
    with TableInfo<ConversationTable, ConversationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, joinedAt, isArchived, isDeleted];
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
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
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

class ConversationTableData extends DataClass
    implements Insertable<ConversationTableData> {
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

  factory ConversationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
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
          {String? id,
          int? type,
          DateTime? joinedAt,
          bool? isArchived,
          bool? isDeleted}) =>
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
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
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

class ConversationTableCompanion
    extends UpdateCompanion<ConversationTableData> {
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

class EventMessageTable extends Table
    with TableInfo<EventMessageTable, EventMessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EventMessageTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
      'kind', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>(
      'pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> masterPubkey = GeneratedColumn<String>(
      'master_pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> eventReference = GeneratedColumn<String>(
      'event_reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kind,
        pubkey,
        masterPubkey,
        createdAt,
        content,
        tags,
        eventReference
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_message_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {eventReference};
  @override
  EventMessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventMessageTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      pubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      masterPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}master_pubkey'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      eventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}event_reference'])!,
    );
  }

  @override
  EventMessageTable createAlias(String alias) {
    return EventMessageTable(attachedDatabase, alias);
  }
}

class EventMessageTableData extends DataClass
    implements Insertable<EventMessageTableData> {
  final String id;
  final int kind;
  final String pubkey;
  final String masterPubkey;
  final DateTime createdAt;
  final String content;
  final String tags;
  final String eventReference;
  const EventMessageTableData(
      {required this.id,
      required this.kind,
      required this.pubkey,
      required this.masterPubkey,
      required this.createdAt,
      required this.content,
      required this.tags,
      required this.eventReference});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<int>(kind);
    map['pubkey'] = Variable<String>(pubkey);
    map['master_pubkey'] = Variable<String>(masterPubkey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['content'] = Variable<String>(content);
    map['tags'] = Variable<String>(tags);
    map['event_reference'] = Variable<String>(eventReference);
    return map;
  }

  EventMessageTableCompanion toCompanion(bool nullToAbsent) {
    return EventMessageTableCompanion(
      id: Value(id),
      kind: Value(kind),
      pubkey: Value(pubkey),
      masterPubkey: Value(masterPubkey),
      createdAt: Value(createdAt),
      content: Value(content),
      tags: Value(tags),
      eventReference: Value(eventReference),
    );
  }

  factory EventMessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventMessageTableData(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<int>(json['kind']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      masterPubkey: serializer.fromJson<String>(json['master_pubkey']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      content: serializer.fromJson<String>(json['content']),
      tags: serializer.fromJson<String>(json['tags']),
      eventReference: serializer.fromJson<String>(json['event_reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<int>(kind),
      'pubkey': serializer.toJson<String>(pubkey),
      'master_pubkey': serializer.toJson<String>(masterPubkey),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'content': serializer.toJson<String>(content),
      'tags': serializer.toJson<String>(tags),
      'event_reference': serializer.toJson<String>(eventReference),
    };
  }

  EventMessageTableData copyWith(
          {String? id,
          int? kind,
          String? pubkey,
          String? masterPubkey,
          DateTime? createdAt,
          String? content,
          String? tags,
          String? eventReference}) =>
      EventMessageTableData(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        pubkey: pubkey ?? this.pubkey,
        masterPubkey: masterPubkey ?? this.masterPubkey,
        createdAt: createdAt ?? this.createdAt,
        content: content ?? this.content,
        tags: tags ?? this.tags,
        eventReference: eventReference ?? this.eventReference,
      );
  EventMessageTableData copyWithCompanion(EventMessageTableCompanion data) {
    return EventMessageTableData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      masterPubkey: data.masterPubkey.present
          ? data.masterPubkey.value
          : this.masterPubkey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      content: data.content.present ? data.content.value : this.content,
      tags: data.tags.present ? data.tags.value : this.tags,
      eventReference: data.eventReference.present
          ? data.eventReference.value
          : this.eventReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventMessageTableData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('content: $content, ')
          ..write('tags: $tags, ')
          ..write('eventReference: $eventReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, kind, pubkey, masterPubkey, createdAt, content, tags, eventReference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventMessageTableData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.pubkey == this.pubkey &&
          other.masterPubkey == this.masterPubkey &&
          other.createdAt == this.createdAt &&
          other.content == this.content &&
          other.tags == this.tags &&
          other.eventReference == this.eventReference);
}

class EventMessageTableCompanion
    extends UpdateCompanion<EventMessageTableData> {
  final Value<String> id;
  final Value<int> kind;
  final Value<String> pubkey;
  final Value<String> masterPubkey;
  final Value<DateTime> createdAt;
  final Value<String> content;
  final Value<String> tags;
  final Value<String> eventReference;
  final Value<int> rowid;
  const EventMessageTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.masterPubkey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.content = const Value.absent(),
    this.tags = const Value.absent(),
    this.eventReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventMessageTableCompanion.insert({
    required String id,
    required int kind,
    required String pubkey,
    required String masterPubkey,
    required DateTime createdAt,
    required String content,
    required String tags,
    required String eventReference,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        kind = Value(kind),
        pubkey = Value(pubkey),
        masterPubkey = Value(masterPubkey),
        createdAt = Value(createdAt),
        content = Value(content),
        tags = Value(tags),
        eventReference = Value(eventReference);
  static Insertable<EventMessageTableData> custom({
    Expression<String>? id,
    Expression<int>? kind,
    Expression<String>? pubkey,
    Expression<String>? masterPubkey,
    Expression<DateTime>? createdAt,
    Expression<String>? content,
    Expression<String>? tags,
    Expression<String>? eventReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (pubkey != null) 'pubkey': pubkey,
      if (masterPubkey != null) 'master_pubkey': masterPubkey,
      if (createdAt != null) 'created_at': createdAt,
      if (content != null) 'content': content,
      if (tags != null) 'tags': tags,
      if (eventReference != null) 'event_reference': eventReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventMessageTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? kind,
      Value<String>? pubkey,
      Value<String>? masterPubkey,
      Value<DateTime>? createdAt,
      Value<String>? content,
      Value<String>? tags,
      Value<String>? eventReference,
      Value<int>? rowid}) {
    return EventMessageTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      pubkey: pubkey ?? this.pubkey,
      masterPubkey: masterPubkey ?? this.masterPubkey,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      eventReference: eventReference ?? this.eventReference,
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
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (masterPubkey.present) {
      map['master_pubkey'] = Variable<String>(masterPubkey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (eventReference.present) {
      map['event_reference'] = Variable<String>(eventReference.value);
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
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('createdAt: $createdAt, ')
          ..write('content: $content, ')
          ..write('tags: $tags, ')
          ..write('eventReference: $eventReference, ')
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES conversation_table (id)'));
  late final GeneratedColumn<String> messageEventReference =
      GeneratedColumn<String>('message_event_reference', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES event_message_table (event_reference)'));
  @override
  List<GeneratedColumn> get $columns => [conversationId, messageEventReference];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_message_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {messageEventReference};
  @override
  ConversationMessageTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationMessageTableData(
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      messageEventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}message_event_reference'])!,
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
  final String messageEventReference;
  const ConversationMessageTableData(
      {required this.conversationId, required this.messageEventReference});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['message_event_reference'] = Variable<String>(messageEventReference);
    return map;
  }

  ConversationMessageTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationMessageTableCompanion(
      conversationId: Value(conversationId),
      messageEventReference: Value(messageEventReference),
    );
  }

  factory ConversationMessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationMessageTableData(
      conversationId: serializer.fromJson<String>(json['conversation_id']),
      messageEventReference:
          serializer.fromJson<String>(json['message_event_reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversation_id': serializer.toJson<String>(conversationId),
      'message_event_reference':
          serializer.toJson<String>(messageEventReference),
    };
  }

  ConversationMessageTableData copyWith(
          {String? conversationId, String? messageEventReference}) =>
      ConversationMessageTableData(
        conversationId: conversationId ?? this.conversationId,
        messageEventReference:
            messageEventReference ?? this.messageEventReference,
      );
  ConversationMessageTableData copyWithCompanion(
      ConversationMessageTableCompanion data) {
    return ConversationMessageTableData(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      messageEventReference: data.messageEventReference.present
          ? data.messageEventReference.value
          : this.messageEventReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMessageTableData(')
          ..write('conversationId: $conversationId, ')
          ..write('messageEventReference: $messageEventReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(conversationId, messageEventReference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationMessageTableData &&
          other.conversationId == this.conversationId &&
          other.messageEventReference == this.messageEventReference);
}

class ConversationMessageTableCompanion
    extends UpdateCompanion<ConversationMessageTableData> {
  final Value<String> conversationId;
  final Value<String> messageEventReference;
  final Value<int> rowid;
  const ConversationMessageTableCompanion({
    this.conversationId = const Value.absent(),
    this.messageEventReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationMessageTableCompanion.insert({
    required String conversationId,
    required String messageEventReference,
    this.rowid = const Value.absent(),
  })  : conversationId = Value(conversationId),
        messageEventReference = Value(messageEventReference);
  static Insertable<ConversationMessageTableData> custom({
    Expression<String>? conversationId,
    Expression<String>? messageEventReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (messageEventReference != null)
        'message_event_reference': messageEventReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationMessageTableCompanion copyWith(
      {Value<String>? conversationId,
      Value<String>? messageEventReference,
      Value<int>? rowid}) {
    return ConversationMessageTableCompanion(
      conversationId: conversationId ?? this.conversationId,
      messageEventReference:
          messageEventReference ?? this.messageEventReference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (messageEventReference.present) {
      map['message_event_reference'] =
          Variable<String>(messageEventReference.value);
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
          ..write('messageEventReference: $messageEventReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MessageStatusTable extends Table
    with TableInfo<MessageStatusTable, MessageStatusTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessageStatusTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> messageEventReference =
      GeneratedColumn<String>('message_event_reference', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES event_message_table (event_reference)'));
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>(
      'pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> masterPubkey = GeneratedColumn<String>(
      'master_pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageEventReference, pubkey, masterPubkey, status];
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
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      messageEventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}message_event_reference'])!,
      pubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      masterPubkey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}master_pubkey'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
    );
  }

  @override
  MessageStatusTable createAlias(String alias) {
    return MessageStatusTable(attachedDatabase, alias);
  }
}

class MessageStatusTableData extends DataClass
    implements Insertable<MessageStatusTableData> {
  final int id;
  final String messageEventReference;
  final String pubkey;
  final String masterPubkey;
  final int status;
  const MessageStatusTableData(
      {required this.id,
      required this.messageEventReference,
      required this.pubkey,
      required this.masterPubkey,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_event_reference'] = Variable<String>(messageEventReference);
    map['pubkey'] = Variable<String>(pubkey);
    map['master_pubkey'] = Variable<String>(masterPubkey);
    map['status'] = Variable<int>(status);
    return map;
  }

  MessageStatusTableCompanion toCompanion(bool nullToAbsent) {
    return MessageStatusTableCompanion(
      id: Value(id),
      messageEventReference: Value(messageEventReference),
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
      messageEventReference:
          serializer.fromJson<String>(json['message_event_reference']),
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
      'message_event_reference':
          serializer.toJson<String>(messageEventReference),
      'pubkey': serializer.toJson<String>(pubkey),
      'master_pubkey': serializer.toJson<String>(masterPubkey),
      'status': serializer.toJson<int>(status),
    };
  }

  MessageStatusTableData copyWith(
          {int? id,
          String? messageEventReference,
          String? pubkey,
          String? masterPubkey,
          int? status}) =>
      MessageStatusTableData(
        id: id ?? this.id,
        messageEventReference:
            messageEventReference ?? this.messageEventReference,
        pubkey: pubkey ?? this.pubkey,
        masterPubkey: masterPubkey ?? this.masterPubkey,
        status: status ?? this.status,
      );
  MessageStatusTableData copyWithCompanion(MessageStatusTableCompanion data) {
    return MessageStatusTableData(
      id: data.id.present ? data.id.value : this.id,
      messageEventReference: data.messageEventReference.present
          ? data.messageEventReference.value
          : this.messageEventReference,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      masterPubkey: data.masterPubkey.present
          ? data.masterPubkey.value
          : this.masterPubkey,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageStatusTableData(')
          ..write('id: $id, ')
          ..write('messageEventReference: $messageEventReference, ')
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageEventReference, pubkey, masterPubkey, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageStatusTableData &&
          other.id == this.id &&
          other.messageEventReference == this.messageEventReference &&
          other.pubkey == this.pubkey &&
          other.masterPubkey == this.masterPubkey &&
          other.status == this.status);
}

class MessageStatusTableCompanion
    extends UpdateCompanion<MessageStatusTableData> {
  final Value<int> id;
  final Value<String> messageEventReference;
  final Value<String> pubkey;
  final Value<String> masterPubkey;
  final Value<int> status;
  const MessageStatusTableCompanion({
    this.id = const Value.absent(),
    this.messageEventReference = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.masterPubkey = const Value.absent(),
    this.status = const Value.absent(),
  });
  MessageStatusTableCompanion.insert({
    this.id = const Value.absent(),
    required String messageEventReference,
    required String pubkey,
    required String masterPubkey,
    required int status,
  })  : messageEventReference = Value(messageEventReference),
        pubkey = Value(pubkey),
        masterPubkey = Value(masterPubkey),
        status = Value(status);
  static Insertable<MessageStatusTableData> custom({
    Expression<int>? id,
    Expression<String>? messageEventReference,
    Expression<String>? pubkey,
    Expression<String>? masterPubkey,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageEventReference != null)
        'message_event_reference': messageEventReference,
      if (pubkey != null) 'pubkey': pubkey,
      if (masterPubkey != null) 'master_pubkey': masterPubkey,
      if (status != null) 'status': status,
    });
  }

  MessageStatusTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? messageEventReference,
      Value<String>? pubkey,
      Value<String>? masterPubkey,
      Value<int>? status}) {
    return MessageStatusTableCompanion(
      id: id ?? this.id,
      messageEventReference:
          messageEventReference ?? this.messageEventReference,
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
    if (messageEventReference.present) {
      map['message_event_reference'] =
          Variable<String>(messageEventReference.value);
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
          ..write('messageEventReference: $messageEventReference, ')
          ..write('pubkey: $pubkey, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class ReactionTable extends Table
    with TableInfo<ReactionTable, ReactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ReactionTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> reactionEventReference =
      GeneratedColumn<String>('reaction_event_reference', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES event_message_table (event_reference)'));
  late final GeneratedColumn<String> messageEventReference =
      GeneratedColumn<String>('message_event_reference', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES event_message_table (event_reference)'));
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
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [
        reactionEventReference,
        messageEventReference,
        content,
        masterPubkey,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reaction_table';
  @override
  Set<GeneratedColumn> get $primaryKey =>
      {reactionEventReference, masterPubkey};
  @override
  ReactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReactionTableData(
      reactionEventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reaction_event_reference'])!,
      messageEventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}message_event_reference'])!,
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

class ReactionTableData extends DataClass
    implements Insertable<ReactionTableData> {
  final String reactionEventReference;
  final String messageEventReference;
  final String content;
  final String masterPubkey;
  final bool isDeleted;
  const ReactionTableData(
      {required this.reactionEventReference,
      required this.messageEventReference,
      required this.content,
      required this.masterPubkey,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reaction_event_reference'] = Variable<String>(reactionEventReference);
    map['message_event_reference'] = Variable<String>(messageEventReference);
    map['content'] = Variable<String>(content);
    map['master_pubkey'] = Variable<String>(masterPubkey);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ReactionTableCompanion toCompanion(bool nullToAbsent) {
    return ReactionTableCompanion(
      reactionEventReference: Value(reactionEventReference),
      messageEventReference: Value(messageEventReference),
      content: Value(content),
      masterPubkey: Value(masterPubkey),
      isDeleted: Value(isDeleted),
    );
  }

  factory ReactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReactionTableData(
      reactionEventReference:
          serializer.fromJson<String>(json['reaction_event_reference']),
      messageEventReference:
          serializer.fromJson<String>(json['message_event_reference']),
      content: serializer.fromJson<String>(json['content']),
      masterPubkey: serializer.fromJson<String>(json['master_pubkey']),
      isDeleted: serializer.fromJson<bool>(json['is_deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reaction_event_reference':
          serializer.toJson<String>(reactionEventReference),
      'message_event_reference':
          serializer.toJson<String>(messageEventReference),
      'content': serializer.toJson<String>(content),
      'master_pubkey': serializer.toJson<String>(masterPubkey),
      'is_deleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ReactionTableData copyWith(
          {String? reactionEventReference,
          String? messageEventReference,
          String? content,
          String? masterPubkey,
          bool? isDeleted}) =>
      ReactionTableData(
        reactionEventReference:
            reactionEventReference ?? this.reactionEventReference,
        messageEventReference:
            messageEventReference ?? this.messageEventReference,
        content: content ?? this.content,
        masterPubkey: masterPubkey ?? this.masterPubkey,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ReactionTableData copyWithCompanion(ReactionTableCompanion data) {
    return ReactionTableData(
      reactionEventReference: data.reactionEventReference.present
          ? data.reactionEventReference.value
          : this.reactionEventReference,
      messageEventReference: data.messageEventReference.present
          ? data.messageEventReference.value
          : this.messageEventReference,
      content: data.content.present ? data.content.value : this.content,
      masterPubkey: data.masterPubkey.present
          ? data.masterPubkey.value
          : this.masterPubkey,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReactionTableData(')
          ..write('reactionEventReference: $reactionEventReference, ')
          ..write('messageEventReference: $messageEventReference, ')
          ..write('content: $content, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reactionEventReference, messageEventReference,
      content, masterPubkey, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReactionTableData &&
          other.reactionEventReference == this.reactionEventReference &&
          other.messageEventReference == this.messageEventReference &&
          other.content == this.content &&
          other.masterPubkey == this.masterPubkey &&
          other.isDeleted == this.isDeleted);
}

class ReactionTableCompanion extends UpdateCompanion<ReactionTableData> {
  final Value<String> reactionEventReference;
  final Value<String> messageEventReference;
  final Value<String> content;
  final Value<String> masterPubkey;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ReactionTableCompanion({
    this.reactionEventReference = const Value.absent(),
    this.messageEventReference = const Value.absent(),
    this.content = const Value.absent(),
    this.masterPubkey = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionTableCompanion.insert({
    required String reactionEventReference,
    required String messageEventReference,
    required String content,
    required String masterPubkey,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : reactionEventReference = Value(reactionEventReference),
        messageEventReference = Value(messageEventReference),
        content = Value(content),
        masterPubkey = Value(masterPubkey);
  static Insertable<ReactionTableData> custom({
    Expression<String>? reactionEventReference,
    Expression<String>? messageEventReference,
    Expression<String>? content,
    Expression<String>? masterPubkey,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reactionEventReference != null)
        'reaction_event_reference': reactionEventReference,
      if (messageEventReference != null)
        'message_event_reference': messageEventReference,
      if (content != null) 'content': content,
      if (masterPubkey != null) 'master_pubkey': masterPubkey,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionTableCompanion copyWith(
      {Value<String>? reactionEventReference,
      Value<String>? messageEventReference,
      Value<String>? content,
      Value<String>? masterPubkey,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ReactionTableCompanion(
      reactionEventReference:
          reactionEventReference ?? this.reactionEventReference,
      messageEventReference:
          messageEventReference ?? this.messageEventReference,
      content: content ?? this.content,
      masterPubkey: masterPubkey ?? this.masterPubkey,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reactionEventReference.present) {
      map['reaction_event_reference'] =
          Variable<String>(reactionEventReference.value);
    }
    if (messageEventReference.present) {
      map['message_event_reference'] =
          Variable<String>(messageEventReference.value);
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
          ..write('reactionEventReference: $reactionEventReference, ')
          ..write('messageEventReference: $messageEventReference, ')
          ..write('content: $content, ')
          ..write('masterPubkey: $masterPubkey, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class MessageMediaTable extends Table
    with TableInfo<MessageMediaTable, MessageMediaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessageMediaTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> remoteUrl = GeneratedColumn<String>(
      'remote_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> messageEventReference =
      GeneratedColumn<String>('message_event_reference', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES event_message_table (event_reference)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, status, remoteUrl, cacheKey, messageEventReference];
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
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      remoteUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_url']),
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key']),
      messageEventReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}message_event_reference'])!,
    );
  }

  @override
  MessageMediaTable createAlias(String alias) {
    return MessageMediaTable(attachedDatabase, alias);
  }
}

class MessageMediaTableData extends DataClass
    implements Insertable<MessageMediaTableData> {
  final int id;
  final int status;
  final String? remoteUrl;
  final String? cacheKey;
  final String messageEventReference;
  const MessageMediaTableData(
      {required this.id,
      required this.status,
      this.remoteUrl,
      this.cacheKey,
      required this.messageEventReference});
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
    map['message_event_reference'] = Variable<String>(messageEventReference);
    return map;
  }

  MessageMediaTableCompanion toCompanion(bool nullToAbsent) {
    return MessageMediaTableCompanion(
      id: Value(id),
      status: Value(status),
      remoteUrl: remoteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUrl),
      cacheKey: cacheKey == null && nullToAbsent
          ? const Value.absent()
          : Value(cacheKey),
      messageEventReference: Value(messageEventReference),
    );
  }

  factory MessageMediaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageMediaTableData(
      id: serializer.fromJson<int>(json['id']),
      status: serializer.fromJson<int>(json['status']),
      remoteUrl: serializer.fromJson<String?>(json['remote_url']),
      cacheKey: serializer.fromJson<String?>(json['cache_key']),
      messageEventReference:
          serializer.fromJson<String>(json['message_event_reference']),
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
      'message_event_reference':
          serializer.toJson<String>(messageEventReference),
    };
  }

  MessageMediaTableData copyWith(
          {int? id,
          int? status,
          Value<String?> remoteUrl = const Value.absent(),
          Value<String?> cacheKey = const Value.absent(),
          String? messageEventReference}) =>
      MessageMediaTableData(
        id: id ?? this.id,
        status: status ?? this.status,
        remoteUrl: remoteUrl.present ? remoteUrl.value : this.remoteUrl,
        cacheKey: cacheKey.present ? cacheKey.value : this.cacheKey,
        messageEventReference:
            messageEventReference ?? this.messageEventReference,
      );
  MessageMediaTableData copyWithCompanion(MessageMediaTableCompanion data) {
    return MessageMediaTableData(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      remoteUrl: data.remoteUrl.present ? data.remoteUrl.value : this.remoteUrl,
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      messageEventReference: data.messageEventReference.present
          ? data.messageEventReference.value
          : this.messageEventReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageMediaTableData(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('remoteUrl: $remoteUrl, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('messageEventReference: $messageEventReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, status, remoteUrl, cacheKey, messageEventReference);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageMediaTableData &&
          other.id == this.id &&
          other.status == this.status &&
          other.remoteUrl == this.remoteUrl &&
          other.cacheKey == this.cacheKey &&
          other.messageEventReference == this.messageEventReference);
}

class MessageMediaTableCompanion
    extends UpdateCompanion<MessageMediaTableData> {
  final Value<int> id;
  final Value<int> status;
  final Value<String?> remoteUrl;
  final Value<String?> cacheKey;
  final Value<String> messageEventReference;
  const MessageMediaTableCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.remoteUrl = const Value.absent(),
    this.cacheKey = const Value.absent(),
    this.messageEventReference = const Value.absent(),
  });
  MessageMediaTableCompanion.insert({
    this.id = const Value.absent(),
    required int status,
    this.remoteUrl = const Value.absent(),
    this.cacheKey = const Value.absent(),
    required String messageEventReference,
  })  : status = Value(status),
        messageEventReference = Value(messageEventReference);
  static Insertable<MessageMediaTableData> custom({
    Expression<int>? id,
    Expression<int>? status,
    Expression<String>? remoteUrl,
    Expression<String>? cacheKey,
    Expression<String>? messageEventReference,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (remoteUrl != null) 'remote_url': remoteUrl,
      if (cacheKey != null) 'cache_key': cacheKey,
      if (messageEventReference != null)
        'message_event_reference': messageEventReference,
    });
  }

  MessageMediaTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? status,
      Value<String?>? remoteUrl,
      Value<String?>? cacheKey,
      Value<String>? messageEventReference}) {
    return MessageMediaTableCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      cacheKey: cacheKey ?? this.cacheKey,
      messageEventReference:
          messageEventReference ?? this.messageEventReference,
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
    if (messageEventReference.present) {
      map['message_event_reference'] =
          Variable<String>(messageEventReference.value);
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
          ..write('messageEventReference: $messageEventReference')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final ConversationTable conversationTable = ConversationTable(this);
  late final EventMessageTable eventMessageTable = EventMessageTable(this);
  late final ConversationMessageTable conversationMessageTable =
      ConversationMessageTable(this);
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
  int get schemaVersion => 1;
}
