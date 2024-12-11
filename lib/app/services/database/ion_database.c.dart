// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/extensions/extensions.dart';
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

  Future<int> insertEventMessage(EventMessage eventMessage) {
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
    return into(conversationMessagesTable).insert(
      ConversationMessagesTableData(
        isDeleted: isDeleted,
        conversationId: conversationId,
        eventMessageId: eventMessage.id,
        createdAt: eventMessage.createdAt,
        subject: eventMessage.subject,
        pubKeys: eventMessage.pubkeysMask,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<String?> _lookupConversationByPubkeys(
    EventMessage eventMessage,
  ) async {
    final conversationsWithSameParticipants = await (select(conversationMessagesTable)
          ..where(
            (table) => table.pubKeys.equals(eventMessage.pubkeysMask),
          )
          ..limit(1))
        .get();

    if (conversationsWithSameParticipants.isEmpty) {
      // Check if there are conversations with the same subject but different pubkeys
      // (this means that amount of participants in conversation was changed)
      final subject = eventMessage.subject;
      if (subject != null) {
        final conversationsWithChangedParticipants = await (select(conversationMessagesTable)
              ..where(
                (table) => table.subject.equals(subject),
              )
              ..limit(1))
            .get();

        return conversationsWithChangedParticipants.isEmpty
            ? null
            : conversationsWithChangedParticipants.first.conversationId;
      }
      return null;
    }

    return conversationsWithSameParticipants.first.conversationId;
  }

  Future<int> insertEventMessage(EventMessage eventMessage) async {
    final i = await into(eventMessagesTable).insert(
      EventMessageTableData.fromEventMessage(eventMessage),
      mode: InsertMode.insertOrReplace,
    );

    await _updateConversationMessagesTable(eventMessage);

    return i;
  }

  // Inserts new conversation id or returns existing one
  Future<void> _updateConversationMessagesTable(
    EventMessage eventMessage,
  ) async {
    if (eventMessage.kind == 14) {
      // This is the first message of the one-to-one conversation OR
      // change of the group conversation subject
      if (eventMessage.content.isEmpty) {
        final uuid = const Uuid().v1();
        await insertConversationData(
          conversationId: uuid,
          eventMessage: eventMessage,
        );
      } else {
        // This is next message of existing conversation
        final conversationId = await _lookupConversationByPubkeys(eventMessage);
        if (conversationId != null) {
          await insertConversationData(
            conversationId: conversationId,
            eventMessage: eventMessage,
          );
        }
      }
    }
  }

  Future<List<EventMessage>> getAllConversations() async {
    // Select last message of each conversation
    final uniqueConversationRows = await customSelect(
      'SELECT * FROM (SELECT * FROM conversation_messages_table ORDER BY created_at DESC) AS sub GROUP BY conversation_id',
      readsFrom: {conversationMessagesTable},
    ).get();

    final lastConversationMessagesIds =
        uniqueConversationRows.map((row) => row.data['event_message_id'] as String).toList();

    final lastConversationEventMessages = (await (select(eventMessagesTable)
              ..where((table) => table.id.isIn(lastConversationMessagesIds)))
            .get())
        .map((e) => e.toEventMessage())
        .toList();

    return lastConversationEventMessages;
  }

  Stream<List<EventMessage>> watchConversations() {
    return customSelect(
      'SELECT * FROM (SELECT * FROM conversation_messages_table ORDER BY created_at DESC) AS sub GROUP BY conversation_id',
      readsFrom: {conversationMessagesTable},
    ).watch().asyncMap((rows) async {
      final lastConversationMessagesIds =
          rows.map((row) => row.data['event_message_id'] as String).toList();

      final lastConversationEventMessages = (await (select(eventMessagesTable)
                ..where((table) => table.id.isIn(lastConversationMessagesIds)))
              .get())
          .map((e) => e.toEventMessage())
          .toList();

      return lastConversationEventMessages;
    });
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

// Test data
/*
 final ionDatabase = ref.watch(ionDatabaseProvider).requireValue;

  // Initial message for one-to-one conversation
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '0',
      pubkey: 'pubkey0',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
      ],
      content: '',
      sig: null,
    ),
  );

    // Next message for the one-to-one conversation
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '1',
      pubkey: 'pubkey1',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
      ],
      content: 'Message 1',
      sig: null,
    ),
  );

    
  // Initial message for the group conversation
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '0',
      pubkey: 'pubkey0',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
        ['p', 'pubkey2'],
        ['p', 'pubkey3'],
        ['p', 'pubkey4'],
        ['subject', 'Test group'],
      ],
      content: '',
      sig: null,
    ),
  );

  // Next message for the group conversation
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '1',
      pubkey: 'pubkey1',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
        ['p', 'pubkey2'],
        ['p', 'pubkey3'],
        ['p', 'pubkey4'],
        ['subject', 'Test group'],
      ],
      content: 'Message 1',
      sig: null,
    ),
  );

  // Change of the group conversation subject
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '2',
      pubkey: 'pubkey1',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
        ['p', 'pubkey2'],
        ['p', 'pubkey3'],
        ['p', 'pubkey4'],
        ['subject', 'Test group change'],
      ],
      content: 'Change of the group conversation subject',
      sig: null,
    ),
  );

  // Change of the group conversation participants
  await ionDatabase.insertEventMessage(
    EventMessage(
      id: '3',
      pubkey: 'pubkey1',
      kind: 14,
      createdAt: DateTime.now(),
      tags: const [
        ['p', 'pubkey1'],
        ['p', 'pubkey2'],
        ['p', 'pubkey3'],
        ['p', 'pubkey4'],
        ['p', 'pubkey5'],
        ['subject', 'Test group change'],
      ],
      content: 'Change of the group conversation participants',
      sig: null,
    ),
  );



*/
