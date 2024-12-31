// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'conversation_db_service.c.g.dart';

@Riverpod(keepAlive: true)
ConversationsDBService conversationsDBService(Ref ref) =>
    ConversationsDBService(ref.watch(ionDatabaseProvider));

class ConversationsDBService {
  ConversationsDBService(this._db);

  final IONDatabase _db;

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

  // TODO: Try to implement in a single transaction
  //https://drift.simonbinder.eu/dart_api/transactions/?h=transa
  Future<void> insertEventMessage(EventMessage eventMessage) async {
    await _db.into(_db.eventMessagesTable).insert(
          EventMessageTableData.fromEventMessage(eventMessage),
          mode: InsertMode.insertOrReplace,
        );

    await _db.transaction<bool>(() async {
      return true;
    });

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
    if (eventMessage.kind != PrivateDirectMessageEntity.kind) return;

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

    if (subject == null) return null;

    final conversationWithChangedParticipants = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.subject.equals(subject))
          ..limit(1))
        .get();

    if (conversationWithChangedParticipants.isNotEmpty) {
      return conversationWithChangedParticipants.first.conversationId;
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

  Future<void> markConversationMessageAsDeleted(String id) async {
    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.eventMessageId.equals(id)))
        .getSingle();

    final deleteConversationMessagesTableData =
        conversationMessagesTableData.copyWith(isDeleted: true);

    await _db.update(_db.conversationMessagesTable).replace(deleteConversationMessagesTableData);
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

  // Mark conversation as removed and all its messages prior to last message as
  // deleted
  Future<void> deleteConversation(String conversationId) async {
    await _db.into(_db.deletedConversationTable).insert(
          DeletedConversationTableCompanion(
            conversationId: Value(conversationId),
            deletedAt: Value(DateTime.now().toUtc()),
          ),
          mode: InsertMode.insertOrReplace,
        );

    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.conversationId.equals(conversationId)))
        .get();

    final deleteConversationMessagesTableData =
        conversationMessagesTableData.map((e) => e.copyWith(isDeleted: true)).toList();

    await _db.batch(
      (b) {
        b.replaceAll(
          _db.conversationMessagesTable,
          deleteConversationMessagesTableData,
        );
      },
    );
  }
}
