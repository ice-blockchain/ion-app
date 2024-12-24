// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ion_database.c.g.dart';

// Proxy notifier to interact with the database
@Riverpod(keepAlive: true)
class DBConversationsNotifier extends _$DBConversationsNotifier {
  DBConversationsNotifier({IONDatabase? database}) : _db = database ?? IONDatabase();

  final IONDatabase _db;

  @override
  void build() {}

  Future<int> _insertConversationData({
    required String conversationId,
    required EventMessage eventMessage,
    bool isDeleted = false,
  }) {
    final conversationMessage = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
    return _db.into(_db.conversationMessagesTable).insert(
          ConversationMessagesTableData(
            isDeleted: isDeleted,
            conversationId: conversationId,
            eventMessageId: conversationMessage.id,
            createdAt: conversationMessage.createdAt,
            pubKeys: conversationMessage.allPubkeysMask,
            subject: conversationMessage.data.relatedSubject?.value,
            status: DeliveryStatus.none,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<int> _insertConversationReactionsTableData(EventMessage eventMessage) {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(eventMessage);

    return _db.into(_db.conversationReactionsTable).insert(
          ConversationReactionsTableData(
            reactionEventId: reactionEntity.id,
            createdAt: reactionEntity.createdAt,
            content: reactionEntity.data.content,
            messageId: reactionEntity.data.eventId,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> insertEventMessage(EventMessage eventMessage) async {
    await _db.into(_db.eventMessagesTable).insert(
          EventMessageTableData.fromEventMessage(eventMessage),
          mode: InsertMode.insertOrReplace,
        );

    if (eventMessage.kind == PrivateDirectMessageEntity.kind) {
      await _updateConversationMessagesTable(eventMessage);
    } else if (eventMessage.kind == PrivateMessageReactionEntity.kind) {
      switch (eventMessage.content) {
        case 'received':
          await _updateConversationMessageAsReceived(eventMessage);
        case 'read':
          await _updateConversationMessagesAsRead(eventMessage);
        default:
          await _insertConversationReactionsTableData(eventMessage);
      }
    }
  }

  Future<void> _updateConversationMessagesTable(
    EventMessage eventMessage,
  ) async {
    if (eventMessage.kind == PrivateDirectMessageEntity.kind) {
      final conversationMessage = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
      final conversationIdByPubkeys = await _lookupConversationByPubkeys(conversationMessage);

      if (conversationIdByPubkeys != null) {
        // Existing conversation (one-to-one or group)
        await _insertConversationData(
          eventMessage: eventMessage,
          conversationId: conversationIdByPubkeys,
        );
      } else {
        // Existing group conversation (change of participants)
        final conversationIdBySubject = await _lookupConversationBySubject(conversationMessage);

        if (conversationIdBySubject != null) {
          await _insertConversationData(
            eventMessage: eventMessage,
            conversationId: conversationIdBySubject,
          );
        } else if (eventMessage.content.isEmpty) {
          // New conversation
          final uuid = const Uuid().v1();
          await _insertConversationData(
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
    final conversationsWithSameParticipants = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.pubKeys.equals(conversationMessage.allPubkeysMask),
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
      final conversationWithChangedParticipants = await (_db.select(_db.conversationMessagesTable)
            ..where((table) => table.subject.equals(subject))
            ..limit(1))
          .get();

      if (conversationWithChangedParticipants.isNotEmpty) {
        return conversationWithChangedParticipants.first.conversationId;
      }
    }
    return null;
  }

  // Call when "OK" is received from relay to mark message as sent (one tick)
  Future<void> markConversationMessageAsSent(String id) async {
    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.eventMessageId.equals(id)))
        .getSingle();

    final sentConversationMessagesTableData =
        conversationMessagesTableData.copyWith(status: DeliveryStatus.isSent);

    await _db.update(_db.conversationMessagesTable).replace(sentConversationMessagesTableData);
  }

  // Call when kind 7 is received from relay with "received" content
  Future<void> _updateConversationMessageAsReceived(
    EventMessage eventMessage,
  ) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(eventMessage);

    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.eventMessageId.equals(reactionEntity.data.eventId),
          ))
        .getSingle();

    final receivedConversationMessagesTableData =
        conversationMessagesTableData.copyWith(status: DeliveryStatus.isReceived);

    await _db.update(_db.conversationMessagesTable).replace(receivedConversationMessagesTableData);
  }

  // Call when kind 7 is received from relay with "read" content
  Future<void> _updateConversationMessagesAsRead(
    EventMessage eventMessage,
  ) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(eventMessage);

    final latestConversationMessageTableData = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.eventMessageId.equals(reactionEntity.data.eventId),
          ))
        .getSingle();

    final allPreviousReceivedMessages = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) =>
                table.conversationId.equals(latestConversationMessageTableData.conversationId),
          )
          ..where(
            (table) => table.status.equals(DeliveryStatus.isReceived.index),
          )
          ..where(
            (table) => table.createdAt.isSmallerOrEqualValue(
              latestConversationMessageTableData.createdAt,
            ),
          ))
        .get();

    await _db.batch(
      (b) {
        b.replaceAll(
          _db.conversationMessagesTable,
          allPreviousReceivedMessages
              .map(
                (previousMessage) => previousMessage.copyWith(status: DeliveryStatus.isRead),
              )
              .toList(),
        );
      },
    );
  }

  final _allConversationsLatestMessageQuery =
      'SELECT * FROM (SELECT * FROM conversation_messages_table ORDER BY created_at DESC) AS sub GROUP BY conversation_id';

  Future<List<EventMessage>> getAllConversations() async {
    // Select last message of each conversation
    final uniqueConversationRows = await _db.customSelect(
      _allConversationsLatestMessageQuery,
      readsFrom: {_db.conversationMessagesTable},
    ).get();

    final lastConversationEventMessages =
        await _selectLastMessageOfEachConversation(uniqueConversationRows);

    return lastConversationEventMessages;
  }

  Stream<List<EventMessage>> watchConversations() {
    return _db
        .customSelect(
          _allConversationsLatestMessageQuery,
          readsFrom: {_db.conversationMessagesTable},
        )
        .watch()
        .asyncMap((uniqueConversationRows) async {
          final lastConversationEventMessages = await _selectLastMessageOfEachConversation(
            uniqueConversationRows,
          );

          return lastConversationEventMessages;
        });
  }

  Future<List<EventMessage>> _selectLastMessageOfEachConversation(
    List<QueryRow> uniqueConversationRows,
  ) async {
    final lastConversationMessagesIds =
        uniqueConversationRows.map((row) => row.data['event_message_id'] as String).toList();

    final lastConversationEventMessages = (await (_db.select(_db.eventMessagesTable)
              ..where((table) => table.id.isIn(lastConversationMessagesIds)))
            .get())
        .map((e) => e.toEventMessage())
        .toList();

    return lastConversationEventMessages;
  }

  Future<List<PrivateMessageReactionEntity>> getMessageReactions(
    String messageId,
  ) async {
    final reactionsEventMessagesIds = (await (_db.select(_db.conversationReactionsTable)
              ..where(
                (table) => table.messageId.equals(messageId),
              ))
            .get())
        .map((reactionsTableData) => reactionsTableData.reactionEventId)
        .toList();

    final reactionsEventMessages = await (_db.select(_db.eventMessagesTable)
          ..where((table) => table.id.isIn(reactionsEventMessagesIds)))
        .get();

    final reactions = reactionsEventMessages
        .map(
          (reactionEventMessageData) => PrivateMessageReactionEntity.fromEventMessage(
            reactionEventMessageData.toEventMessage(),
          ),
        )
        .toList();

    return reactions;
  }

  //get last createdAt date from conversation_messages_table
  Future<DateTime?> getLastConversationMessageCreatedAt() async {
    final lastConversationMessage = await (_db.select(_db.conversationMessagesTable)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(1))
        .getSingleOrNull();

    return lastConversationMessage?.createdAt;
  }
}

// DO NOT create or use database directly, use proxy notifier
// [IONDatabaseNotifier] methods instead
@DriftDatabase(
  tables: [
    EventMessagesTable,
    ConversationMessagesTable,
    ConversationReactionsTable,
  ],
)
class IONDatabase extends _$IONDatabase {
  IONDatabase() : super(_openConnection());

  // For testing executor
  IONDatabase.test(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ion_database');
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

enum DeliveryStatus { none, isSent, isReceived, isRead }

// Table for conversations (is automatically updated when
// [EventMessagesTable] is updated with new records)
class ConversationMessagesTable extends Table {
  TextColumn get pubKeys => text()();
  TextColumn get conversationId => text()();
  TextColumn get eventMessageId => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get subject => text().nullable()();
  IntColumn get status => intEnum<DeliveryStatus>()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

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
