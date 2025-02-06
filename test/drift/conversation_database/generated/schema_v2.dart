// SPDX-License-Identifier: ice License 1.0

// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class EventMessagesTable extends Table with TableInfo<EventMessagesTable, EventMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EventMessagesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> sig = GeneratedColumn<String>('sig', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> tags = GeneratedColumn<String>('tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> kind = GeneratedColumn<int>('kind', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sig, tags, pubkey, kind, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_messages_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventMessagesTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sig: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sig']),
      tags: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  EventMessagesTable createAlias(String alias) {
    return EventMessagesTable(attachedDatabase, alias);
  }
}

class EventMessagesTableData extends DataClass implements Insertable<EventMessagesTableData> {
  final String id;
  final String? sig;
  final String tags;
  final String pubkey;
  final int kind;
  final String content;
  final DateTime createdAt;
  const EventMessagesTableData(
      {required this.id,
      this.sig,
      required this.tags,
      required this.pubkey,
      required this.kind,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sig != null) {
      map['sig'] = Variable<String>(sig);
    }
    map['tags'] = Variable<String>(tags);
    map['pubkey'] = Variable<String>(pubkey);
    map['kind'] = Variable<int>(kind);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EventMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return EventMessagesTableCompanion(
      id: Value(id),
      sig: sig == null && nullToAbsent ? const Value.absent() : Value(sig),
      tags: Value(tags),
      pubkey: Value(pubkey),
      kind: Value(kind),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory EventMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      sig: serializer.fromJson<String?>(json['sig']),
      tags: serializer.fromJson<String>(json['tags']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      kind: serializer.fromJson<int>(json['kind']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sig': serializer.toJson<String?>(sig),
      'tags': serializer.toJson<String>(tags),
      'pubkey': serializer.toJson<String>(pubkey),
      'kind': serializer.toJson<int>(kind),
      'content': serializer.toJson<String>(content),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  EventMessagesTableData copyWith(
          {String? id,
          Value<String?> sig = const Value.absent(),
          String? tags,
          String? pubkey,
          int? kind,
          String? content,
          DateTime? createdAt}) =>
      EventMessagesTableData(
        id: id ?? this.id,
        sig: sig.present ? sig.value : this.sig,
        tags: tags ?? this.tags,
        pubkey: pubkey ?? this.pubkey,
        kind: kind ?? this.kind,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  EventMessagesTableData copyWithCompanion(EventMessagesTableCompanion data) {
    return EventMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      sig: data.sig.present ? data.sig.value : this.sig,
      tags: data.tags.present ? data.tags.value : this.tags,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      kind: data.kind.present ? data.kind.value : this.kind,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventMessagesTableData(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sig, tags, pubkey, kind, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventMessagesTableData &&
          other.id == this.id &&
          other.sig == this.sig &&
          other.tags == this.tags &&
          other.pubkey == this.pubkey &&
          other.kind == this.kind &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class EventMessagesTableCompanion extends UpdateCompanion<EventMessagesTableData> {
  final Value<String> id;
  final Value<String?> sig;
  final Value<String> tags;
  final Value<String> pubkey;
  final Value<int> kind;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EventMessagesTableCompanion({
    this.id = const Value.absent(),
    this.sig = const Value.absent(),
    this.tags = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.kind = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventMessagesTableCompanion.insert({
    required String id,
    this.sig = const Value.absent(),
    required String tags,
    required String pubkey,
    required int kind,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tags = Value(tags),
        pubkey = Value(pubkey),
        kind = Value(kind),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<EventMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? sig,
    Expression<String>? tags,
    Expression<String>? pubkey,
    Expression<int>? kind,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sig != null) 'sig': sig,
      if (tags != null) 'tags': tags,
      if (pubkey != null) 'pubkey': pubkey,
      if (kind != null) 'kind': kind,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventMessagesTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? sig,
      Value<String>? tags,
      Value<String>? pubkey,
      Value<int>? kind,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EventMessagesTableCompanion(
      id: id ?? this.id,
      sig: sig ?? this.sig,
      tags: tags ?? this.tags,
      pubkey: pubkey ?? this.pubkey,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sig.present) {
      map['sig'] = Variable<String>(sig.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
    return (StringBuffer('EventMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ConversationMessagesTable extends Table
    with TableInfo<ConversationMessagesTable, ConversationMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationMessagesTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> pubKeys = GeneratedColumn<String>(
      'pub_keys', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> eventMessageId = GeneratedColumn<String>(
      'event_message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> subject = GeneratedColumn<String>('subject', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> status = GeneratedColumn<int>('status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> groupImagePath = GeneratedColumn<String>(
      'group_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        pubKeys,
        conversationId,
        eventMessageId,
        createdAt,
        subject,
        status,
        groupImagePath,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_messages_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {eventMessageId};
  @override
  ConversationMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationMessagesTableData(
      pubKeys: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pub_keys'])!,
      conversationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      eventMessageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_message_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      subject:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}subject']),
      status:
          attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      groupImagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_image_path']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  ConversationMessagesTable createAlias(String alias) {
    return ConversationMessagesTable(attachedDatabase, alias);
  }
}

class ConversationMessagesTableData extends DataClass
    implements Insertable<ConversationMessagesTableData> {
  final String pubKeys;
  final String conversationId;
  final String eventMessageId;
  final DateTime createdAt;
  final String? subject;
  final int status;
  final String? groupImagePath;
  final bool isDeleted;
  const ConversationMessagesTableData(
      {required this.pubKeys,
      required this.conversationId,
      required this.eventMessageId,
      required this.createdAt,
      this.subject,
      required this.status,
      this.groupImagePath,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pub_keys'] = Variable<String>(pubKeys);
    map['conversation_id'] = Variable<String>(conversationId);
    map['event_message_id'] = Variable<String>(eventMessageId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || subject != null) {
      map['subject'] = Variable<String>(subject);
    }
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || groupImagePath != null) {
      map['group_image_path'] = Variable<String>(groupImagePath);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ConversationMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationMessagesTableCompanion(
      pubKeys: Value(pubKeys),
      conversationId: Value(conversationId),
      eventMessageId: Value(eventMessageId),
      createdAt: Value(createdAt),
      subject: subject == null && nullToAbsent ? const Value.absent() : Value(subject),
      status: Value(status),
      groupImagePath:
          groupImagePath == null && nullToAbsent ? const Value.absent() : Value(groupImagePath),
      isDeleted: Value(isDeleted),
    );
  }

  factory ConversationMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationMessagesTableData(
      pubKeys: serializer.fromJson<String>(json['pub_keys']),
      conversationId: serializer.fromJson<String>(json['conversation_id']),
      eventMessageId: serializer.fromJson<String>(json['event_message_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      subject: serializer.fromJson<String?>(json['subject']),
      status: serializer.fromJson<int>(json['status']),
      groupImagePath: serializer.fromJson<String?>(json['group_image_path']),
      isDeleted: serializer.fromJson<bool>(json['is_deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pub_keys': serializer.toJson<String>(pubKeys),
      'conversation_id': serializer.toJson<String>(conversationId),
      'event_message_id': serializer.toJson<String>(eventMessageId),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'subject': serializer.toJson<String?>(subject),
      'status': serializer.toJson<int>(status),
      'group_image_path': serializer.toJson<String?>(groupImagePath),
      'is_deleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ConversationMessagesTableData copyWith(
          {String? pubKeys,
          String? conversationId,
          String? eventMessageId,
          DateTime? createdAt,
          Value<String?> subject = const Value.absent(),
          int? status,
          Value<String?> groupImagePath = const Value.absent(),
          bool? isDeleted}) =>
      ConversationMessagesTableData(
        pubKeys: pubKeys ?? this.pubKeys,
        conversationId: conversationId ?? this.conversationId,
        eventMessageId: eventMessageId ?? this.eventMessageId,
        createdAt: createdAt ?? this.createdAt,
        subject: subject.present ? subject.value : this.subject,
        status: status ?? this.status,
        groupImagePath: groupImagePath.present ? groupImagePath.value : this.groupImagePath,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ConversationMessagesTableData copyWithCompanion(ConversationMessagesTableCompanion data) {
    return ConversationMessagesTableData(
      pubKeys: data.pubKeys.present ? data.pubKeys.value : this.pubKeys,
      conversationId: data.conversationId.present ? data.conversationId.value : this.conversationId,
      eventMessageId: data.eventMessageId.present ? data.eventMessageId.value : this.eventMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      subject: data.subject.present ? data.subject.value : this.subject,
      status: data.status.present ? data.status.value : this.status,
      groupImagePath: data.groupImagePath.present ? data.groupImagePath.value : this.groupImagePath,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMessagesTableData(')
          ..write('pubKeys: $pubKeys, ')
          ..write('conversationId: $conversationId, ')
          ..write('eventMessageId: $eventMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('groupImagePath: $groupImagePath, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pubKeys, conversationId, eventMessageId, createdAt, subject,
      status, groupImagePath, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationMessagesTableData &&
          other.pubKeys == this.pubKeys &&
          other.conversationId == this.conversationId &&
          other.eventMessageId == this.eventMessageId &&
          other.createdAt == this.createdAt &&
          other.subject == this.subject &&
          other.status == this.status &&
          other.groupImagePath == this.groupImagePath &&
          other.isDeleted == this.isDeleted);
}

class ConversationMessagesTableCompanion extends UpdateCompanion<ConversationMessagesTableData> {
  final Value<String> pubKeys;
  final Value<String> conversationId;
  final Value<String> eventMessageId;
  final Value<DateTime> createdAt;
  final Value<String?> subject;
  final Value<int> status;
  final Value<String?> groupImagePath;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ConversationMessagesTableCompanion({
    this.pubKeys = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.eventMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.subject = const Value.absent(),
    this.status = const Value.absent(),
    this.groupImagePath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationMessagesTableCompanion.insert({
    required String pubKeys,
    required String conversationId,
    required String eventMessageId,
    required DateTime createdAt,
    this.subject = const Value.absent(),
    required int status,
    this.groupImagePath = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : pubKeys = Value(pubKeys),
        conversationId = Value(conversationId),
        eventMessageId = Value(eventMessageId),
        createdAt = Value(createdAt),
        status = Value(status);
  static Insertable<ConversationMessagesTableData> custom({
    Expression<String>? pubKeys,
    Expression<String>? conversationId,
    Expression<String>? eventMessageId,
    Expression<DateTime>? createdAt,
    Expression<String>? subject,
    Expression<int>? status,
    Expression<String>? groupImagePath,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pubKeys != null) 'pub_keys': pubKeys,
      if (conversationId != null) 'conversation_id': conversationId,
      if (eventMessageId != null) 'event_message_id': eventMessageId,
      if (createdAt != null) 'created_at': createdAt,
      if (subject != null) 'subject': subject,
      if (status != null) 'status': status,
      if (groupImagePath != null) 'group_image_path': groupImagePath,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationMessagesTableCompanion copyWith(
      {Value<String>? pubKeys,
      Value<String>? conversationId,
      Value<String>? eventMessageId,
      Value<DateTime>? createdAt,
      Value<String?>? subject,
      Value<int>? status,
      Value<String?>? groupImagePath,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ConversationMessagesTableCompanion(
      pubKeys: pubKeys ?? this.pubKeys,
      conversationId: conversationId ?? this.conversationId,
      eventMessageId: eventMessageId ?? this.eventMessageId,
      createdAt: createdAt ?? this.createdAt,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      groupImagePath: groupImagePath ?? this.groupImagePath,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pubKeys.present) {
      map['pub_keys'] = Variable<String>(pubKeys.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (eventMessageId.present) {
      map['event_message_id'] = Variable<String>(eventMessageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (groupImagePath.present) {
      map['group_image_path'] = Variable<String>(groupImagePath.value);
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
    return (StringBuffer('ConversationMessagesTableCompanion(')
          ..write('pubKeys: $pubKeys, ')
          ..write('conversationId: $conversationId, ')
          ..write('eventMessageId: $eventMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('groupImagePath: $groupImagePath, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ConversationReactionsTable extends Table
    with TableInfo<ConversationReactionsTable, ConversationReactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationReactionsTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> reactionEventId = GeneratedColumn<String>(
      'reaction_event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [content, messageId, reactionEventId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_reactions_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {reactionEventId};
  @override
  ConversationReactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationReactionsTableData(
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      reactionEventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reaction_event_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  ConversationReactionsTable createAlias(String alias) {
    return ConversationReactionsTable(attachedDatabase, alias);
  }
}

class ConversationReactionsTableData extends DataClass
    implements Insertable<ConversationReactionsTableData> {
  final String content;
  final String messageId;
  final String reactionEventId;
  final DateTime createdAt;
  const ConversationReactionsTableData(
      {required this.content,
      required this.messageId,
      required this.reactionEventId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content'] = Variable<String>(content);
    map['message_id'] = Variable<String>(messageId);
    map['reaction_event_id'] = Variable<String>(reactionEventId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ConversationReactionsTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationReactionsTableCompanion(
      content: Value(content),
      messageId: Value(messageId),
      reactionEventId: Value(reactionEventId),
      createdAt: Value(createdAt),
    );
  }

  factory ConversationReactionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationReactionsTableData(
      content: serializer.fromJson<String>(json['content']),
      messageId: serializer.fromJson<String>(json['message_id']),
      reactionEventId: serializer.fromJson<String>(json['reaction_event_id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content': serializer.toJson<String>(content),
      'message_id': serializer.toJson<String>(messageId),
      'reaction_event_id': serializer.toJson<String>(reactionEventId),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ConversationReactionsTableData copyWith(
          {String? content, String? messageId, String? reactionEventId, DateTime? createdAt}) =>
      ConversationReactionsTableData(
        content: content ?? this.content,
        messageId: messageId ?? this.messageId,
        reactionEventId: reactionEventId ?? this.reactionEventId,
        createdAt: createdAt ?? this.createdAt,
      );
  ConversationReactionsTableData copyWithCompanion(ConversationReactionsTableCompanion data) {
    return ConversationReactionsTableData(
      content: data.content.present ? data.content.value : this.content,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      reactionEventId:
          data.reactionEventId.present ? data.reactionEventId.value : this.reactionEventId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationReactionsTableData(')
          ..write('content: $content, ')
          ..write('messageId: $messageId, ')
          ..write('reactionEventId: $reactionEventId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(content, messageId, reactionEventId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationReactionsTableData &&
          other.content == this.content &&
          other.messageId == this.messageId &&
          other.reactionEventId == this.reactionEventId &&
          other.createdAt == this.createdAt);
}

class ConversationReactionsTableCompanion extends UpdateCompanion<ConversationReactionsTableData> {
  final Value<String> content;
  final Value<String> messageId;
  final Value<String> reactionEventId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ConversationReactionsTableCompanion({
    this.content = const Value.absent(),
    this.messageId = const Value.absent(),
    this.reactionEventId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationReactionsTableCompanion.insert({
    required String content,
    required String messageId,
    required String reactionEventId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : content = Value(content),
        messageId = Value(messageId),
        reactionEventId = Value(reactionEventId),
        createdAt = Value(createdAt);
  static Insertable<ConversationReactionsTableData> custom({
    Expression<String>? content,
    Expression<String>? messageId,
    Expression<String>? reactionEventId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (content != null) 'content': content,
      if (messageId != null) 'message_id': messageId,
      if (reactionEventId != null) 'reaction_event_id': reactionEventId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationReactionsTableCompanion copyWith(
      {Value<String>? content,
      Value<String>? messageId,
      Value<String>? reactionEventId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ConversationReactionsTableCompanion(
      content: content ?? this.content,
      messageId: messageId ?? this.messageId,
      reactionEventId: reactionEventId ?? this.reactionEventId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (reactionEventId.present) {
      map['reaction_event_id'] = Variable<String>(reactionEventId.value);
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
    return (StringBuffer('ConversationReactionsTableCompanion(')
          ..write('content: $content, ')
          ..write('messageId: $messageId, ')
          ..write('reactionEventId: $reactionEventId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ConversationTable extends Table with TableInfo<ConversationTable, ConversationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ConversationTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> sig = GeneratedColumn<String>('sig', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> tags = GeneratedColumn<String>('tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> kind = GeneratedColumn<int>('kind', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sig, tags, pubkey, kind, content, createdAt];
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
      sig: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sig']),
      tags: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  ConversationTable createAlias(String alias) {
    return ConversationTable(attachedDatabase, alias);
  }
}

class ConversationTableData extends DataClass implements Insertable<ConversationTableData> {
  final String id;
  final String? sig;
  final String tags;
  final String pubkey;
  final int kind;
  final String content;
  final DateTime createdAt;
  const ConversationTableData(
      {required this.id,
      this.sig,
      required this.tags,
      required this.pubkey,
      required this.kind,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sig != null) {
      map['sig'] = Variable<String>(sig);
    }
    map['tags'] = Variable<String>(tags);
    map['pubkey'] = Variable<String>(pubkey);
    map['kind'] = Variable<int>(kind);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ConversationTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationTableCompanion(
      id: Value(id),
      sig: sig == null && nullToAbsent ? const Value.absent() : Value(sig),
      tags: Value(tags),
      pubkey: Value(pubkey),
      kind: Value(kind),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory ConversationTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationTableData(
      id: serializer.fromJson<String>(json['id']),
      sig: serializer.fromJson<String?>(json['sig']),
      tags: serializer.fromJson<String>(json['tags']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      kind: serializer.fromJson<int>(json['kind']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sig': serializer.toJson<String?>(sig),
      'tags': serializer.toJson<String>(tags),
      'pubkey': serializer.toJson<String>(pubkey),
      'kind': serializer.toJson<int>(kind),
      'content': serializer.toJson<String>(content),
      'created_at': serializer.toJson<DateTime>(createdAt),
    };
  }

  ConversationTableData copyWith(
          {String? id,
          Value<String?> sig = const Value.absent(),
          String? tags,
          String? pubkey,
          int? kind,
          String? content,
          DateTime? createdAt}) =>
      ConversationTableData(
        id: id ?? this.id,
        sig: sig.present ? sig.value : this.sig,
        tags: tags ?? this.tags,
        pubkey: pubkey ?? this.pubkey,
        kind: kind ?? this.kind,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  ConversationTableData copyWithCompanion(ConversationTableCompanion data) {
    return ConversationTableData(
      id: data.id.present ? data.id.value : this.id,
      sig: data.sig.present ? data.sig.value : this.sig,
      tags: data.tags.present ? data.tags.value : this.tags,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      kind: data.kind.present ? data.kind.value : this.kind,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationTableData(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sig, tags, pubkey, kind, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationTableData &&
          other.id == this.id &&
          other.sig == this.sig &&
          other.tags == this.tags &&
          other.pubkey == this.pubkey &&
          other.kind == this.kind &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class ConversationTableCompanion extends UpdateCompanion<ConversationTableData> {
  final Value<String> id;
  final Value<String?> sig;
  final Value<String> tags;
  final Value<String> pubkey;
  final Value<int> kind;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ConversationTableCompanion({
    this.id = const Value.absent(),
    this.sig = const Value.absent(),
    this.tags = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.kind = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationTableCompanion.insert({
    required String id,
    this.sig = const Value.absent(),
    required String tags,
    required String pubkey,
    required int kind,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tags = Value(tags),
        pubkey = Value(pubkey),
        kind = Value(kind),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ConversationTableData> custom({
    Expression<String>? id,
    Expression<String>? sig,
    Expression<String>? tags,
    Expression<String>? pubkey,
    Expression<int>? kind,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sig != null) 'sig': sig,
      if (tags != null) 'tags': tags,
      if (pubkey != null) 'pubkey': pubkey,
      if (kind != null) 'kind': kind,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? sig,
      Value<String>? tags,
      Value<String>? pubkey,
      Value<int>? kind,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ConversationTableCompanion(
      id: id ?? this.id,
      sig: sig ?? this.sig,
      tags: tags ?? this.tags,
      pubkey: pubkey ?? this.pubkey,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sig.present) {
      map['sig'] = Variable<String>(sig.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
    return (StringBuffer('ConversationTableCompanion(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CommunityMessageTable extends Table
    with TableInfo<CommunityMessageTable, CommunityMessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CommunityMessageTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> sig = GeneratedColumn<String>('sig', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<String> tags = GeneratedColumn<String>('tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> pubkey = GeneratedColumn<String>('pubkey', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> kind = GeneratedColumn<int>('kind', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES conversation_table (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sig, tags, pubkey, kind, content, createdAt, conversationId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_message_table';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommunityMessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityMessageTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sig: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sig']),
      tags: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      pubkey:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pubkey'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      conversationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
    );
  }

  @override
  CommunityMessageTable createAlias(String alias) {
    return CommunityMessageTable(attachedDatabase, alias);
  }
}

class CommunityMessageTableData extends DataClass implements Insertable<CommunityMessageTableData> {
  final String id;
  final String? sig;
  final String tags;
  final String pubkey;
  final int kind;
  final String content;
  final DateTime createdAt;
  final String conversationId;
  const CommunityMessageTableData(
      {required this.id,
      this.sig,
      required this.tags,
      required this.pubkey,
      required this.kind,
      required this.content,
      required this.createdAt,
      required this.conversationId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || sig != null) {
      map['sig'] = Variable<String>(sig);
    }
    map['tags'] = Variable<String>(tags);
    map['pubkey'] = Variable<String>(pubkey);
    map['kind'] = Variable<int>(kind);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['conversation_id'] = Variable<String>(conversationId);
    return map;
  }

  CommunityMessageTableCompanion toCompanion(bool nullToAbsent) {
    return CommunityMessageTableCompanion(
      id: Value(id),
      sig: sig == null && nullToAbsent ? const Value.absent() : Value(sig),
      tags: Value(tags),
      pubkey: Value(pubkey),
      kind: Value(kind),
      content: Value(content),
      createdAt: Value(createdAt),
      conversationId: Value(conversationId),
    );
  }

  factory CommunityMessageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityMessageTableData(
      id: serializer.fromJson<String>(json['id']),
      sig: serializer.fromJson<String?>(json['sig']),
      tags: serializer.fromJson<String>(json['tags']),
      pubkey: serializer.fromJson<String>(json['pubkey']),
      kind: serializer.fromJson<int>(json['kind']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      conversationId: serializer.fromJson<String>(json['conversation_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sig': serializer.toJson<String?>(sig),
      'tags': serializer.toJson<String>(tags),
      'pubkey': serializer.toJson<String>(pubkey),
      'kind': serializer.toJson<int>(kind),
      'content': serializer.toJson<String>(content),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'conversation_id': serializer.toJson<String>(conversationId),
    };
  }

  CommunityMessageTableData copyWith(
          {String? id,
          Value<String?> sig = const Value.absent(),
          String? tags,
          String? pubkey,
          int? kind,
          String? content,
          DateTime? createdAt,
          String? conversationId}) =>
      CommunityMessageTableData(
        id: id ?? this.id,
        sig: sig.present ? sig.value : this.sig,
        tags: tags ?? this.tags,
        pubkey: pubkey ?? this.pubkey,
        kind: kind ?? this.kind,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        conversationId: conversationId ?? this.conversationId,
      );
  CommunityMessageTableData copyWithCompanion(CommunityMessageTableCompanion data) {
    return CommunityMessageTableData(
      id: data.id.present ? data.id.value : this.id,
      sig: data.sig.present ? data.sig.value : this.sig,
      tags: data.tags.present ? data.tags.value : this.tags,
      pubkey: data.pubkey.present ? data.pubkey.value : this.pubkey,
      kind: data.kind.present ? data.kind.value : this.kind,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      conversationId: data.conversationId.present ? data.conversationId.value : this.conversationId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMessageTableData(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('conversationId: $conversationId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sig, tags, pubkey, kind, content, createdAt, conversationId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityMessageTableData &&
          other.id == this.id &&
          other.sig == this.sig &&
          other.tags == this.tags &&
          other.pubkey == this.pubkey &&
          other.kind == this.kind &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.conversationId == this.conversationId);
}

class CommunityMessageTableCompanion extends UpdateCompanion<CommunityMessageTableData> {
  final Value<String> id;
  final Value<String?> sig;
  final Value<String> tags;
  final Value<String> pubkey;
  final Value<int> kind;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<String> conversationId;
  final Value<int> rowid;
  const CommunityMessageTableCompanion({
    this.id = const Value.absent(),
    this.sig = const Value.absent(),
    this.tags = const Value.absent(),
    this.pubkey = const Value.absent(),
    this.kind = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommunityMessageTableCompanion.insert({
    required String id,
    this.sig = const Value.absent(),
    required String tags,
    required String pubkey,
    required int kind,
    required String content,
    required DateTime createdAt,
    required String conversationId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tags = Value(tags),
        pubkey = Value(pubkey),
        kind = Value(kind),
        content = Value(content),
        createdAt = Value(createdAt),
        conversationId = Value(conversationId);
  static Insertable<CommunityMessageTableData> custom({
    Expression<String>? id,
    Expression<String>? sig,
    Expression<String>? tags,
    Expression<String>? pubkey,
    Expression<int>? kind,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<String>? conversationId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sig != null) 'sig': sig,
      if (tags != null) 'tags': tags,
      if (pubkey != null) 'pubkey': pubkey,
      if (kind != null) 'kind': kind,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (conversationId != null) 'conversation_id': conversationId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommunityMessageTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? sig,
      Value<String>? tags,
      Value<String>? pubkey,
      Value<int>? kind,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<String>? conversationId,
      Value<int>? rowid}) {
    return CommunityMessageTableCompanion(
      id: id ?? this.id,
      sig: sig ?? this.sig,
      tags: tags ?? this.tags,
      pubkey: pubkey ?? this.pubkey,
      kind: kind ?? this.kind,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sig.present) {
      map['sig'] = Variable<String>(sig.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (pubkey.present) {
      map['pubkey'] = Variable<String>(pubkey.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMessageTableCompanion(')
          ..write('id: $id, ')
          ..write('sig: $sig, ')
          ..write('tags: $tags, ')
          ..write('pubkey: $pubkey, ')
          ..write('kind: $kind, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('conversationId: $conversationId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final EventMessagesTable eventMessagesTable = EventMessagesTable(this);
  late final ConversationMessagesTable conversationMessagesTable = ConversationMessagesTable(this);
  late final ConversationReactionsTable conversationReactionsTable =
      ConversationReactionsTable(this);
  late final ConversationTable conversationTable = ConversationTable(this);
  late final CommunityMessageTable communityMessageTable = CommunityMessageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        eventMessagesTable,
        conversationMessagesTable,
        conversationReactionsTable,
        conversationTable,
        communityMessageTable
      ];
  @override
  int get schemaVersion => 2;
}
