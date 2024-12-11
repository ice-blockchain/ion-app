// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ion_database.c.g.dart';

// Proxy notifier to interact with the database
@Riverpod(keepAlive: true)
class IONDatabaseNotifier extends _$IONDatabaseNotifier {
  final IONDatabase _ionDatabase = IONDatabase();

  @override
  void build() {}

  Future<void> insertEventMessage(EventMessage eventMessage) {
    return _ionDatabase.insertEventMessage(eventMessage);
  }

  Future<List<EventMessage>> getAllConversations() {
    return _ionDatabase.getAllConversations();
  }

  Stream<List<EventMessage>> watchConversations() {
    return _ionDatabase.watchConversations();
  }
}

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(tables: [EventMessagesTable, ConversationMessagesTable])
class IONDatabase extends _$IONDatabase {
  IONDatabase() : super(_openConnection());

  // For testing executor
  IONDatabase.test(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ion_database');
  }

  Future<int> insertConversationData({
    required String conversationId,
    required EventMessage eventMessage,
    bool isDeleted = false,
  }) {
    final conversationMessage =
        PrivateDirectMessageEntity.fromEventMessage(eventMessage);
    return into(conversationMessagesTable).insert(
      ConversationMessagesTableData(
        isDeleted: isDeleted,
        conversationId: conversationId,
        eventMessageId: conversationMessage.id,
        createdAt: conversationMessage.createdAt,
        pubKeys: conversationMessage.allPubkeysMask,
        subject: conversationMessage.data.relatedSubject?.value,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> insertEventMessage(EventMessage eventMessage) async {
    await into(eventMessagesTable).insert(
      EventMessageTableData.fromEventMessage(eventMessage),
      mode: InsertMode.insertOrReplace,
    );

    await _updateConversationMessagesTable(eventMessage);
  }

  Future<void> _updateConversationMessagesTable(
    EventMessage eventMessage,
  ) async {
    if (eventMessage.kind == PrivateDirectMessageEntity.kind) {
      final conversationMessage =
          PrivateDirectMessageEntity.fromEventMessage(eventMessage);
      final conversationIdByPubkeys =
          await _lookupConversationByPubkeys(conversationMessage);

      if (conversationIdByPubkeys != null) {
        // Existing conversation (one-to-one or group)
        await insertConversationData(
          eventMessage: eventMessage,
          conversationId: conversationIdByPubkeys,
        );
      } else {
        // Existing group conversation (change of participants)
        final conversationIdBySubject =
            await _lookupConversationBySubject(conversationMessage);

        if (conversationIdBySubject != null) {
          await insertConversationData(
            eventMessage: eventMessage,
            conversationId: conversationIdBySubject,
          );
        } else if (eventMessage.content.isEmpty) {
          // New conversation
          final uuid = const Uuid().v1();
          await insertConversationData(
            eventMessage: eventMessage,
            conversationId: uuid,
          );
        } else {
          // Invalid message (doesn't belong to any conversation)
          throw ConversationIsNotFoundException();
        }
      }
    }
  }

  // Check if there are conversations with the same pubkeys
  Future<String?> _lookupConversationByPubkeys(
    PrivateDirectMessageEntity conversationMessage,
  ) async {
    final conversationsWithSameParticipants =
        await (select(conversationMessagesTable)
              ..where(
                (table) =>
                    table.pubKeys.equals(conversationMessage.allPubkeysMask),
              )
              ..limit(1))
            .get();

    if (conversationsWithSameParticipants.isNotEmpty) {
      return conversationsWithSameParticipants.first.conversationId;
    }

    return null;
  }

  // Check if there are conversations with the same subject but different pubkeys
  // (this means that amount of participants in conversation was changed)
  Future<String?> _lookupConversationBySubject(
    PrivateDirectMessageEntity conversationMessage,
  ) async {
    final subject = conversationMessage.data.relatedSubject?.value;

    if (subject != null) {
      final conversationWithChangedParticipants =
          await (select(conversationMessagesTable)
                ..where((table) => table.subject.equals(subject))
                ..limit(1))
              .get();

      if (conversationWithChangedParticipants.isNotEmpty) {
        return conversationWithChangedParticipants.first.conversationId;
      }
    }
    return null;
  }

  final _allConversationsLatestMessageQuery =
      'SELECT * FROM (SELECT * FROM conversation_messages_table ORDER BY created_at DESC) AS sub GROUP BY conversation_id';

  Future<List<EventMessage>> getAllConversations() async {
    // Select last message of each conversation
    final uniqueConversationRows = await customSelect(
      _allConversationsLatestMessageQuery,
      readsFrom: {conversationMessagesTable},
    ).get();

    final lastConversationEventMessages =
        await _selectLastMessageOfEachConversation(uniqueConversationRows);

    return lastConversationEventMessages;
  }

  Stream<List<EventMessage>> watchConversations() {
    return customSelect(
      _allConversationsLatestMessageQuery,
      readsFrom: {conversationMessagesTable},
    ).watch().asyncMap((uniqueConversationRows) async {
      final lastConversationEventMessages =
          await _selectLastMessageOfEachConversation(uniqueConversationRows);

      return lastConversationEventMessages;
    });
  }

  Future<List<EventMessage>> _selectLastMessageOfEachConversation(
    List<QueryRow> uniqueConversationRows,
  ) async {
    final lastConversationMessagesIds = uniqueConversationRows
        .map((row) => row.data['event_message_id'] as String)
        .toList();

    final lastConversationEventMessages = (await (select(eventMessagesTable)
              ..where((table) => table.id.isIn(lastConversationMessagesIds)))
            .get())
        .map((e) => e.toEventMessage())
        .toList();

    return lastConversationEventMessages;
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

// Table for conversations (is automatically updated when
// [EventMessagesTable] is updated with new records)
class ConversationMessagesTable extends Table {
  TextColumn get pubKeys => text()();
  TextColumn get conversationId => text()();
  TextColumn get eventMessageId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get subject => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {eventMessageId};
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
