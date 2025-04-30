// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageDataDao conversationMessageDataDao(Ref ref) =>
    ConversationMessageDataDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [MessageStatusTable, EventMessageTable, ConversationMessageTable],
)
class ConversationMessageDataDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageDataDaoMixin {
  ConversationMessageDataDao(super.db);

  Future<void> addOrUpdateStatus({
    required String pubkey,
    required String sharedId,
    required String masterPubkey,
    required MessageDeliveryStatus status,
    DateTime? updateAllBefore,
  }) async {
    if (updateAllBefore != null && status == MessageDeliveryStatus.read) {
      // Mark all previous received messages as read prior to the given date
      final unreadResults = await (select(messageStatusTable)
            ..where((table) => table.masterPubkey.equals(masterPubkey))
            ..where((table) => table.status.equals(MessageDeliveryStatus.received.index))
            ..join([
              innerJoin(
                conversationMessageTable,
                conversationMessageTable.sharedId.equalsExp(messageStatusTable.sharedId) &
                    eventMessageTable.createdAt.isSmallerThanValue(updateAllBefore),
              ),
              innerJoin(
                eventMessageTable,
                eventMessageTable.eventReference
                        .equalsExp(conversationMessageTable.eventReferenceId) &
                    eventMessageTable.createdAt.isSmallerThanValue(updateAllBefore),
              ),
            ]))
          .get();

      // Batch update the status of all previous messages to read
      await batch((batch) {
        for (final row in unreadResults) {
          batch.update(
            messageStatusTable,
            const MessageStatusTableCompanion(status: Value(MessageDeliveryStatus.read)),
            where: (table) =>
                table.sharedId.equals(row.sharedId) & table.masterPubkey.equals(row.masterPubkey),
          );
        }
      });
    } else {
      // Fetch the existing status for the given pubkey and sharedId
      final existingStatus = await (select(messageStatusTable)
            ..where((table) => table.pubkey.equals(pubkey))
            ..where((table) => table.sharedId.equals(sharedId)))
          .getSingleOrNull();

      if (existingStatus == null) {
        // Insert a new row if no existing status is found
        await into(messageStatusTable).insert(
          MessageStatusTableCompanion(
            status: Value(status),
            pubkey: Value(pubkey),
            sharedId: Value(sharedId),
            masterPubkey: Value(masterPubkey),
          ),
        );
      } else if (status.index > existingStatus.status.index) {
        // Update the row if the new status has a higher priority
        await (update(messageStatusTable)
              ..where((table) => table.pubkey.equals(pubkey))
              ..where((table) => table.sharedId.equals(sharedId)))
            .write(
          MessageStatusTableCompanion(
            status: Value(status),
          ),
        );
      }
    }
  }

  Stream<MessageDeliveryStatus> messageStatus({
    required String sharedId,
    required String currentUserMasterPubkey,
  }) {
    return (select(messageStatusTable)..where((table) => table.sharedId.equals(sharedId)))
        .watch()
        .map((rows) {
      // If any of the rows are deleted, we consider the message as deleted
      if (rows.any((row) => row.status == MessageDeliveryStatus.deleted)) {
        return MessageDeliveryStatus.deleted;
      } else
      // Check if any of the rows failed (message is not sent, only local copy is
      // written to the database)
      if (rows.any((row) => row.status == MessageDeliveryStatus.failed)) {
        return MessageDeliveryStatus.failed;
      } else
      // Check if any received user device have read status which we consider as read
      if (rows.any(
        (row) =>
            row.status == MessageDeliveryStatus.read && row.masterPubkey != currentUserMasterPubkey,
      )) {
        return MessageDeliveryStatus.read;
      } else
      // Check if any received user device have received status which we consider as received
      if (rows.any(
        (row) =>
            row.status.index == MessageDeliveryStatus.received.index &&
            row.masterPubkey != currentUserMasterPubkey,
      )) {
        return MessageDeliveryStatus.received;
      } else
      // Check if any received user device have higher status then created
      if (rows.any(
        (row) =>
            row.status.index == MessageDeliveryStatus.sent.index &&
            row.masterPubkey != currentUserMasterPubkey,
      )) {
        return MessageDeliveryStatus.sent;
      }
      return MessageDeliveryStatus.created;
    });
  }

  Future<Map<String, MessageDeliveryStatus>> messageStatuses({
    required String sharedId,
    required String masterPubkey,
  }) async {
    final existingRows = await (select(messageStatusTable)
          ..where((table) => table.sharedId.equals(sharedId))
          ..where((table) => table.pubkey.equals(masterPubkey)))
        .get();

    return {for (final row in existingRows) row.masterPubkey: row.status};
  }

  Future<MessageDeliveryStatus?> checkMessageStatus({
    required String sharedId,
    required String masterPubkey,
  }) async {
    final existingDeviceStatuses = await (select(messageStatusTable)
          ..where((table) => table.sharedId.equals(sharedId))
          ..where((table) => table.masterPubkey.equals(masterPubkey)))
        .get();

    return existingDeviceStatuses.isNotEmpty
        ? existingDeviceStatuses
            .map((row) => row.status)
            .reduce((a, b) => a.index > b.index ? a : b)
        : null;
  }
}

enum MessageDeliveryStatus {
  created,
  failed,
  sent,
  received,
  read,
  deleted;
}
