// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/database/conversation_database.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_db_service.c.g.dart';

@Riverpod(keepAlive: true)
ConversationsDBService conversationsDBService(Ref ref) => ConversationsDBService(ref.watch(conversationDatabaseProvider));

class ConversationsDBService {
  ConversationsDBService(this._db);

  final ConversationDatabase _db;

  Future<int> _insertConversationData({
    required String conversationId,
    required EventMessage eventMessage,
    bool isDeleted = false,
  }) async {
    String? groupImagePath;

    final conversationMessage = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
    return _db.into(_db.conversationMessagesTable).insert(
          ConversationMessagesTableData(
            isDeleted: isDeleted,
            groupImagePath: groupImagePath,
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

  Future<int> updateGroupConversationImage({
    required String conversationId,
    required String groupImagePath,
  }) async {
    return (_db.update(_db.conversationMessagesTable)..where((table) => table.conversationId.equals(conversationId)))
        .write(
      ConversationMessagesTableCompanion(
        groupImagePath: Value(groupImagePath),
      ),
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

    final conversationIdByPubkeys = await lookupConversationByPubkeys(conversationMessage.allPubkeysMask);

    if (conversationIdByPubkeys != null) {
      // Existing conversation (one-to-one or group)
      await _insertConversationData(
        eventMessage: eventMessage,
        conversationId: conversationIdByPubkeys,
      );
    } else {
      // Existing group conversation (change of participants)
      final conversationIdBySubject = await lookupConversationBySubject(conversationMessage.data.relatedSubject?.value);

      if (conversationIdBySubject != null) {
        await _insertConversationData(
          eventMessage: eventMessage,
          conversationId: conversationIdBySubject,
        );
      } else {
        // New conversation
        final uuid = generateUuid();
        await _insertConversationData(
          eventMessage: eventMessage,
          conversationId: uuid,
        );
      }
    }
  }

  // Check if there are conversations with the same pubkeys
  Future<String?> lookupConversationByEventMessageId(String eventMessageId) async {
    final conversationMessage = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.eventMessageId.equals(eventMessageId),
          )
          ..limit(1))
        .getSingle();

    return conversationMessage.conversationId;
  }

  // Check if there are conversations with the same pubkeys
  Future<String?> lookupConversationByPubkeys(String allPubkeysMask) async {
    final conversationsWithSameParticipants = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.pubKeys.equals(allPubkeysMask),
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
  Future<String?> lookupConversationBySubject(String? subject) async {
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

    final sentConversationMessagesTableData = conversationMessagesTableData.copyWith(status: DeliveryStatus.isSent);

    await _db.update(_db.conversationMessagesTable).replace(sentConversationMessagesTableData);
  }

  Future<void> markConversationMessageAsDeleted(String id) async {
    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.eventMessageId.equals(id)))
        .getSingle();

    final deleteConversationMessagesTableData = conversationMessagesTableData.copyWith(isDeleted: true);

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
            (table) => table.conversationId.equals(latestConversationMessageTableData.conversationId),
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

  Future<int> getUnreadMessagesCount(String conversationId) {
    return (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.conversationId.equals(conversationId))
          ..where((table) => table.status.equals(DeliveryStatus.isReceived.index)))
        .get()
        .then((value) => value.length);
  }

  Future<void> markConversationsAsRead(List<String> conversationIds) async {
    return _db.batch(
      (b) {
        b.update(
          _db.conversationMessagesTable,
          const ConversationMessagesTableCompanion(status: Value(DeliveryStatus.isRead)),
          where: (table) =>
              table.conversationId.isIn(conversationIds) & table.status.equals(DeliveryStatus.isReceived.index),
        );
      },
    );
  }

  Future<void> markAllConversationsAsRead() async {
    return _db.batch(
      (b) {
        b.update(
          _db.conversationMessagesTable,
          const ConversationMessagesTableCompanion(status: Value(DeliveryStatus.isRead)),
          where: (table) => table.status.equals(DeliveryStatus.isReceived.index),
        );
      },
    );
  }

  final _allConversationsLatestMessageQuery =
      'SELECT * FROM (SELECT * FROM conversation_messages_table WHERE is_deleted = 0 ORDER BY created_at DESC) AS sub GROUP BY conversation_id';

  Future<List<PrivateDirectMessageEntity>> getAllConversations() async {
    // Select last message of each conversation
    final uniqueConversationRows = await _db.customSelect(
      _allConversationsLatestMessageQuery,
      readsFrom: {_db.conversationMessagesTable},
    ).get();

    final lastConversationMessages = await _selectLastMessageOfEachConversation(uniqueConversationRows);

    return lastConversationMessages;
  }

  Future<List<PrivateDirectMessageEntity>> getConversationMessages(
    E2eeConversationEntity conversation,
  ) async {
    late JoinedSelectStatement<HasResultSet, dynamic> query;
    if (conversation.id != null) {
      query = _db.select(_db.conversationMessagesTable).join([
        innerJoin(
          _db.eventMessagesTable,
          _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
        ),
      ])
        ..where(_db.conversationMessagesTable.conversationId.equals(conversation.id!))
        ..where(_db.conversationMessagesTable.isDeleted.equals(false));
    } else {
      query = _db.select(_db.conversationMessagesTable).join([
        innerJoin(
          _db.eventMessagesTable,
          _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
        ),
      ])
        ..where(_db.conversationMessagesTable.pubKeys.equals(conversation.participants.join(',')))
        ..where(_db.conversationMessagesTable.isDeleted.equals(false));
    }

    final data = await query.get();

    final conversationMessages = data.map((row) {
      final eventMessage = row.readTable(_db.eventMessagesTable);
      return PrivateDirectMessageEntity.fromEventMessage(eventMessage.toEventMessage());
    }).toList();

    final sortedConversationMessages = conversationMessages.sortedBy<DateTime>((e) => e.createdAt);

    return sortedConversationMessages;
  }

  Stream<List<PrivateDirectMessageEntity>> watchConversations() {
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

  Stream<List<PrivateDirectMessageEntity>> watchConversationMessages(
    E2eeConversationEntity conversation,
  ) {
    late JoinedSelectStatement<HasResultSet, dynamic> query;

    if (conversation.id != null) {
      query = _db.select(_db.conversationMessagesTable).join([
        innerJoin(
          _db.eventMessagesTable,
          _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
        ),
      ])
        ..where(_db.conversationMessagesTable.conversationId.equals(conversation.id!))
        ..where(_db.conversationMessagesTable.isDeleted.equals(false));
    } else {
      query = _db.select(_db.conversationMessagesTable).join([
        innerJoin(
          _db.eventMessagesTable,
          _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
        ),
      ])
        ..where(_db.conversationMessagesTable.pubKeys.equals(conversation.participants.join(',')))
        ..where(_db.conversationMessagesTable.isDeleted.equals(false));
    }

    return query.watch().map((rows) {
      return rows.map((row) {
        final eventMessage = row.readTable(_db.eventMessagesTable);
        return PrivateDirectMessageEntity.fromEventMessage(eventMessage.toEventMessage());
      }).toList();
    });
  }

  FutureOr<List<PrivateDirectMessageEntity>> _selectLastMessageOfEachConversation(
    List<QueryRow> uniqueConversationRows,
  ) async {
    final lastConversationMessagesId =
        uniqueConversationRows.map((row) => row.data['event_message_id'] as String).toList();

    final lastConversationGroupImagesMap = uniqueConversationRows.map((row) {
      final groupImagePath = {
        row.data['event_message_id'] as String: row.data['group_image_path'] as String?,
      };
      return groupImagePath;
    }).toList();

    final lastConversationEventMessagesTableData =
        await (_db.select(_db.eventMessagesTable)..where((table) => table.id.isIn(lastConversationMessagesId))).get();

    final lastConversationEventMessages = lastConversationEventMessagesTableData.map((e) => e.toEventMessage());

    final lastConversationMessages =
        lastConversationEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

    final lastConversationMessagesWithGroupImages = lastConversationMessages.map((message) {
      final groupImagePath = lastConversationGroupImagesMap.firstWhere(
        (element) => element.containsKey(message.id),
        orElse: () => {message.id: null},
      );

      return message.copyWith(
        data: message.data.copyWith(relatedGroupImagePath: groupImagePath[message.id]),
      );
    }).toList();

    return lastConversationMessagesWithGroupImages;
  }

  Future<List<PrivateMessageReactionEntity>> getMessageReactions(
    String messageId,
  ) async {
    final reactionsEventMessagesIds =
        (await (_db.select(_db.conversationReactionsTable)..where((table) => table.messageId.equals(messageId))).get())
            .map((reactionsTableData) => reactionsTableData.reactionEventId)
            .toList();

    final reactionsEventMessages =
        await (_db.select(_db.eventMessagesTable)..where((table) => table.id.isIn(reactionsEventMessagesIds))).get();

    final reactions = reactionsEventMessages
        .map(
          (reactionEventMessageData) => PrivateMessageReactionEntity.fromEventMessage(
            reactionEventMessageData.toEventMessage(),
          ),
        )
        .toList();

    return reactions;
  }

  // Get last createdAt date from conversation_messages_table
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
    final conversationMessagesTableData = await (_db.select(_db.conversationMessagesTable)
          ..where((table) => table.conversationId.equals(conversationId)))
        .get();

    final deleteConversationMessagesTableData =
        conversationMessagesTableData.map((e) => e.copyWith(isDeleted: true)).toList();

    await _db.batch(
      (b) {
        b.replaceAll(_db.conversationMessagesTable, deleteConversationMessagesTableData);
      },
    );
  }
}
