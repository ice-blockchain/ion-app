// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/database/conversation_database.c.steps.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_database.c.g.dart';

@Riverpod(keepAlive: true)
ConversationDatabase conversationDatabase(Ref ref) => ConversationDatabase();

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    EventMessagesTable,
    ConversationMessagesTable,
    ConversationMessageStatusTable,
    ConversationReactionsTable,
  ],
)
class ConversationDatabase extends _$ConversationDatabase {
  ConversationDatabase() : super(_openConnection());

  // For testing executor
  ConversationDatabase.test(super.e);

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.dropColumn(schema.conversationMessagesTable, 'status');
          await m.dropColumn(schema.conversationMessagesTable, 'is_deleted');
          await m.createTable(schema.conversationMessageStatusTable);
        },
      ),
    );
  }

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'conversation_database');
  }
}

// Table for all EventMessage
@UseRowClass(EventMessageTableData)
class EventMessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get sig => text().nullable()();
  TextColumn get tags => text()();
  TextColumn get pubkey => text()();
  IntColumn get kind => integer()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

enum DeliveryStatus { created, sent, received, read, deleted, failed }

// Table for conversations (is automatically updated when
// [EventMessagesTable] is updated with new records)
class ConversationMessagesTable extends Table {
  TextColumn get pubKeys => text()();
  TextColumn get conversationId => text()();
  TextColumn get eventMessageId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get subject => text().nullable()();
  TextColumn get groupImagePath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {eventMessageId};
}

// Table for delivery statuses of conversation message
class ConversationMessageStatusTable extends Table {
  TextColumn get eventMessageId => text()();
  TextColumn get masterPubkey => text().nullable()();
  IntColumn get status => intEnum<DeliveryStatus>()();

  @override
  Set<Column<Object>> get primaryKey => {eventMessageId};
}

// Table for conversation reactions (is automatically updated when
// [EventMessagesTable] is updated with new records)
class ConversationReactionsTable extends Table {
  TextColumn get content => text()();
  TextColumn get messageId => text()();
  TextColumn get reactionEventId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {reactionEventId};
}

// As it is the only custom model needed better to keep it in the same file
class EventMessageTableData implements Insertable<EventMessageTableData> {
  EventMessageTableData({
    required this.id,
    required this.kind,
    required this.tags,
    required this.pubkey,
    required this.content,
    required this.createdAt,
    this.sig,
    this.conversationId,
  });

  factory EventMessageTableData.fromEventMessage(EventMessage eventMessage) {
    return EventMessageTableData(
      id: eventMessage.id,
      sig: eventMessage.sig,
      kind: eventMessage.kind,
      pubkey: eventMessage.pubkey,
      content: eventMessage.content,
      createdAt: eventMessage.createdAt,
      tags: jsonEncode(eventMessage.tags),
    );
  }

  EventMessage toEventMessage() {
    return EventMessage(
      id: id,
      sig: sig,
      kind: kind,
      pubkey: pubkey,
      content: content,
      createdAt: createdAt,
      tags: (jsonDecode(tags) as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );
  }

  final int kind;
  final String id;
  final String tags;
  final String pubkey;
  final String content;
  final String? sig;
  final String? conversationId;
  final DateTime createdAt;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return EventMessagesTableCompanion(
      id: Value(id),
      sig: Value(sig),
      kind: Value(kind),
      tags: Value(tags),
      pubkey: Value(pubkey),
      content: Value(content),
      createdAt: Value(createdAt),
    ).toColumns(nullToAbsent);
  }

  EventMessageTableData copyWith({
    int? kind,
    String? id,
    String? sig,
    String? tags,
    String? pubkey,
    String? content,
    String? conversationId,
    DateTime? createdAt,
  }) {
    return EventMessageTableData(
      id: id ?? this.id,
      sig: sig ?? this.sig,
      kind: kind ?? this.kind,
      tags: tags ?? this.tags,
      pubkey: pubkey ?? this.pubkey,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
