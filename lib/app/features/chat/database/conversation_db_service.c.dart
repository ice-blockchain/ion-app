// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/database/conversation_database.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/model/message_delivery_status.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_db_service.c.g.dart';

@Riverpod(keepAlive: true)
ConversationsDBService conversationsDBService(Ref ref) =>
    ConversationsDBService(ref.watch(conversationDatabaseProvider));

class ConversationsDBService {
  ConversationsDBService(this._db);

  final ConversationDatabase _db;

  Future<int> _insertConversationMessageData({
    required String conversationId,
    required EventMessage eventMessage,
  }) async {
    String? groupImagePath;

    final conversationMessage = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
    return _db.into(_db.conversationMessagesTable).insert(
          ConversationMessagesTableData(
            groupImagePath: groupImagePath,
            conversationId: conversationId,
            eventMessageId: conversationMessage.id,
            createdAt: conversationMessage.createdAt,
            subject: conversationMessage.data.relatedSubject?.value,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> updateConversationMessageStatusData({
    required String masterPubkey,
    required String eventMessageId,
    required MessageDeliveryStatus status,
  }) async {
    final existingRow = await (_db.select(_db.conversationMessageStatusTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .getSingleOrNull();

    if (existingRow != null) {
      await _db
          .update(_db.conversationMessageStatusTable)
          .replace(existingRow.copyWith(status: status));
    } else {
      await _db.into(_db.conversationMessageStatusTable).insert(
            ConversationMessageStatusTableCompanion(
              status: Value(status),
              masterPubkey: Value(masterPubkey),
              eventMessageId: Value(eventMessageId),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
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

  Future<int> updateGroupConversationImage({
    required String conversationId,
    required String groupImagePath,
  }) async {
    return (_db.update(_db.conversationMessagesTable)
          ..where((table) => table.conversationId.equals(conversationId)))
        .write(
      ConversationMessagesTableCompanion(
        groupImagePath: Value(groupImagePath),
      ),
    );
  }

  // TODO: Try to implement in a single transaction
  //https://drift.simonbinder.eu/dart_api/transactions/?h=transa
  Future<void> insertEventMessage({
    required EventMessage eventMessage,
    required String masterPubkey,
  }) async {
    await _db.into(_db.eventMessagesTable).insert(
          EventMessageTableData.fromEventMessage(eventMessage),
          mode: InsertMode.insertOrReplace,
        );

    if (eventMessage.kind == PrivateDirectMessageEntity.kind) {
      await _updateConversationMessagesTable(eventMessage);
    } else if (eventMessage.kind == PrivateMessageReactionEntity.kind) {
      switch (eventMessage.content) {
        case 'received':
          await _updateConversationMessageAsReceived(
            eventMessage: eventMessage,
            masterPubkey: masterPubkey,
          );
        case 'read':
          await _updateConversationMessagesAsRead(
            eventMessage: eventMessage,
            masterPubkey: masterPubkey,
          );
        default:
          await _insertConversationReactionsTableData(eventMessage);
      }
    }
  }

  Future<void> _updateConversationMessagesTable(EventMessage eventMessage) async {
    if (eventMessage.kind != PrivateDirectMessageEntity.kind) return;

    final conversationMessage = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
    final conversationId = conversationMessage.data.relatedConversationId?.value;

    if (conversationId != null) {
      await _insertConversationMessageData(
        eventMessage: eventMessage,
        conversationId: conversationId,
      );
    }
  }

  final _allConversationsLatestMessageQuery =
      'SELECT * FROM (SELECT * FROM conversation_messages_table ORDER BY created_at DESC) AS sub GROUP BY conversation_id';

  Future<List<PrivateDirectMessageEntity>> getAllConversations() async {
    // Select last message of each conversation
    final uniqueConversationRows = await _db.customSelect(
      _allConversationsLatestMessageQuery,
      readsFrom: {_db.conversationMessagesTable},
    ).get();

    final lastConversationMessages =
        await _selectLastMessageOfEachConversation(uniqueConversationRows);

    return lastConversationMessages;
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

    final lastConversationEventMessagesTableData = await (_db.select(_db.eventMessagesTable)
          ..where((table) => table.id.isIn(lastConversationMessagesId)))
        .get();

    final lastConversationEventMessages =
        lastConversationEventMessagesTableData.map((e) => e.toEventMessage());

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
    final reactionsEventMessagesIds = (await (_db.select(_db.conversationReactionsTable)
              ..where((table) => table.messageId.equals(messageId)))
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

  Future<List<PrivateDirectMessageEntity>> getConversationMessages(String conversationId) async {
    final query = _db.select(_db.conversationMessagesTable).join([
      innerJoin(
        _db.eventMessagesTable,
        _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
      ),
    ])
      ..where(_db.conversationMessagesTable.conversationId.equals(conversationId))
      ..orderBy([OrderingTerm.asc(_db.conversationMessagesTable.createdAt)]);

    final data = await query.get();

    return data.map((row) {
      final eventMessage = row.readTable(_db.eventMessagesTable);

      return PrivateDirectMessageEntity.fromEventMessage(eventMessage.toEventMessage());
    }).toList();
  }

  Stream<List<PrivateDirectMessageEntity>> watchConversationMessages(String conversationId) {
    final query = _db.select(_db.conversationMessagesTable).join([
      innerJoin(
        _db.eventMessagesTable,
        _db.eventMessagesTable.id.equalsExp(_db.conversationMessagesTable.eventMessageId),
      ),
    ])
      ..where(_db.conversationMessagesTable.conversationId.equals(conversationId))
      ..orderBy([OrderingTerm.asc(_db.conversationMessagesTable.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final eventMessage = row.readTable(_db.eventMessagesTable);
        return PrivateDirectMessageEntity.fromEventMessage(eventMessage.toEventMessage());
      }).toList();
    });
  }

  Future<Map<String, MessageDeliveryStatus>> getMessageDeliveryStatuses(
    String eventMessageId,
  ) async {
    final messageStatusesTableData = await (_db.select(_db.conversationMessageStatusTable)
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .get();

    return messageStatusesTableData
        .asMap()
        .map((index, messageStatus) => MapEntry(messageStatus.masterPubkey!, messageStatus.status));
  }

  Stream<Map<String, MessageDeliveryStatus>> watchMessageDeliveryStatus(String eventMessageId) {
    return (_db.select(_db.conversationMessageStatusTable)
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .watch()
        .map(
          (rows) => rows.asMap().map(
                (index, messageStatus) =>
                    MapEntry(messageStatus.masterPubkey!, messageStatus.status),
              ),
        );
  }

  // Kind 7 is received from relay with "received" status
  Future<void> _updateConversationMessageAsReceived({
    required EventMessage eventMessage,
    required String masterPubkey,
  }) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(eventMessage);

    final conversationMessageStatusTableData = await (_db.select(_db.conversationMessageStatusTable)
          ..where((table) => table.eventMessageId.equals(reactionEntity.data.eventId))
          ..where((table) => table.masterPubkey.equals(masterPubkey)))
        .getSingleOrNull();

    if (conversationMessageStatusTableData == null) return;

    final receivedConversationMessageStatusTableData = conversationMessageStatusTableData.copyWith(
      status: MessageDeliveryStatus.received,
    );
    await _db
        .update(_db.conversationMessageStatusTable)
        .replace(receivedConversationMessageStatusTableData);
  }

  // Kind 7 reaction is received from relay with "read" status
  Future<void> _updateConversationMessagesAsRead({
    required EventMessage eventMessage,
    required String masterPubkey,
  }) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(eventMessage);

    final latestMessageWithReadStatusTableData = await (_db.select(_db.conversationMessagesTable)
          ..where(
            (table) => table.eventMessageId.equals(reactionEntity.data.eventId),
          ))
        .getSingleOrNull();

    if (latestMessageWithReadStatusTableData == null) return;

    final previousMessagesWithReceivedStatus =
        await (_db.select(_db.conversationMessageStatusTable).join([
      innerJoin(
        _db.conversationMessagesTable,
        _db.conversationMessagesTable.eventMessageId
            .equalsExp(_db.conversationMessageStatusTable.eventMessageId),
      ),
    ])
              ..where(
                _db.conversationMessagesTable.conversationId
                    .equals(latestMessageWithReadStatusTableData.conversationId),
              )
              ..where(
                _db.conversationMessagesTable.createdAt.isSmallerOrEqualValue(
                  latestMessageWithReadStatusTableData.createdAt,
                ),
              )
              ..where(
                _db.conversationMessageStatusTable.status
                    .equals(MessageDeliveryStatus.received.index),
              )
              ..where(
                _db.conversationMessageStatusTable.masterPubkey.equals(masterPubkey),
              ))
            .get();

    final updatedStatuses = previousMessagesWithReceivedStatus.map((messageStatus) {
      final conversationMessageStatus = messageStatus.readTable(_db.conversationMessageStatusTable);
      return conversationMessageStatus.copyWith(status: MessageDeliveryStatus.read);
    }).toList();

    await _db.batch(
      (b) {
        b.replaceAll(_db.conversationMessageStatusTable, updatedStatuses);
      },
    );
  }

  // Get unread messages for the current user or any other masterPubkey
  Future<int> unreadMessagesCount({
    required String conversationId,
    required String masterPubkey,
  }) async {
    final messageStatusesTableData = await (_db.select(_db.conversationMessagesTable).join([
      leftOuterJoin(
        _db.conversationMessageStatusTable,
        _db.conversationMessageStatusTable.eventMessageId
            .equalsExp(_db.conversationMessagesTable.eventMessageId),
      ),
    ])
          ..where(
            _db.conversationMessageStatusTable.masterPubkey.equals(masterPubkey),
          )
          ..where(
            _db.conversationMessageStatusTable.status.equals(MessageDeliveryStatus.read.index),
          )
          ..where(
            _db.conversationMessagesTable.conversationId.equals(conversationId),
          ))
        .get();

    return messageStatusesTableData.length;
  }

  // Mark all messages in specified conversations for masterPubkey as read
  Future<void> markConversationsAsRead({
    required List<String> conversationIds,
    required String masterPubkey,
  }) async {
    final messageStatusesTableData = await (_db.select(_db.conversationMessagesTable).join([
      leftOuterJoin(
        _db.conversationMessageStatusTable,
        _db.conversationMessageStatusTable.eventMessageId
            .equalsExp(_db.conversationMessagesTable.eventMessageId),
      ),
    ])
          ..where(_db.conversationMessageStatusTable.masterPubkey.equals(masterPubkey))
          ..where(_db.conversationMessagesTable.conversationId.isIn(conversationIds))
          ..where(
            _db.conversationMessageStatusTable.status.equals(MessageDeliveryStatus.received.index),
          ))
        .get();

    if (messageStatusesTableData.isEmpty) return;

    final updatedStatuses = messageStatusesTableData.map((messageStatus) {
      final conversationMessageStatus = messageStatus.readTable(_db.conversationMessageStatusTable);
      return conversationMessageStatus.copyWith(status: MessageDeliveryStatus.read);
    }).toList();

    await _db.batch((batch) {
      batch.replaceAll(_db.conversationMessageStatusTable, updatedStatuses);
    });
  }

  Future<void> markAllConversationsAsRead(String masterPubkey) async {
    final receivedMessages = await (_db.select(_db.conversationMessageStatusTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.status.equals(MessageDeliveryStatus.received.index)))
        .get();

    if (receivedMessages.isEmpty) return;

    final updatedStatuses = receivedMessages.map((messageStatus) {
      return messageStatus.copyWith(status: MessageDeliveryStatus.read);
    }).toList();

    await _db.batch((batch) {
      batch.replaceAll(_db.conversationMessageStatusTable, updatedStatuses);
    });
  }

  // Get the most recent createdAt date from conversation_messages_table
  Future<DateTime?> getLastConversationMessageCreatedAt() async {
    final lastConversationMessage = await (_db.select(_db.conversationMessagesTable)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(1))
        .getSingleOrNull();

    return lastConversationMessage?.createdAt;
  }

  // Call when message is deleted on user local device
  Future<void> deleteMessage({
    required String messageId,
    required String masterPubkey,
  }) async {
    await _db.transaction(() async {
      final conversationMessageStatusTableData =
          await (_db.select(_db.conversationMessageStatusTable)
                ..where((table) => table.eventMessageId.equals(messageId))
                ..where((table) => table.masterPubkey.equals(masterPubkey)))
              .getSingleOrNull();

      if (conversationMessageStatusTableData != null) {
        final updatedConversationMessageStatusTableData =
            conversationMessageStatusTableData.copyWith(
          status: MessageDeliveryStatus.deleted,
        );

        await _db
            .update(_db.conversationMessageStatusTable)
            .replace(updatedConversationMessageStatusTableData);
      }
    });
  }

  // Mark all conversation messages prior to the current time as deleted
  Future<void> deleteConversation({
    required String masterPubkey,
    required String conversationId,
  }) async {
    final messageStatusesTableData = await (_db.select(_db.conversationMessagesTable).join([
      leftOuterJoin(
        _db.conversationMessageStatusTable,
        _db.conversationMessageStatusTable.eventMessageId
            .equalsExp(_db.conversationMessagesTable.eventMessageId),
      ),
    ])
          ..where(
            _db.conversationMessageStatusTable.masterPubkey.equals(masterPubkey),
          )
          ..where(
            _db.conversationMessagesTable.conversationId.equals(conversationId),
          ))
        .get();

    final conversationMessagesStatusTableData = messageStatusesTableData.map((messageStatus) {
      final conversationMessageStatus = messageStatus.readTable(_db.conversationMessageStatusTable);

      return conversationMessageStatus.copyWith(status: MessageDeliveryStatus.deleted);
    });

    await _db.batch(
      (b) {
        b.replaceAll(_db.conversationMessageStatusTable, conversationMessagesStatusTableData);
      },
    );
  }
}
