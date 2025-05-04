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
    required EventReference messageEventReference,
    required String pubkey,
    required String masterPubkey,
    required MessageDeliveryStatus status,
    DateTime? updateAllBefore,
  }) async {
    if (updateAllBefore != null && status == MessageDeliveryStatus.read) {
      //TODO: implement this
      // // Mark all previous received messages as read prior to the given date
      // final unreadResults = await (select(messageStatusTable)
      //       ..where((table) => table.masterPubkey.equals(masterPubkey))
      //       ..where((table) => table.status.equals(MessageDeliveryStatus.received.index))
      //       ..join([
      //         innerJoin(
      //           conversationMessageTable,
      //           conversationMessageTable.messageEventReference
      //                   .equalsExp(messageStatusTable.messageEventReference) &
      //               eventMessageTable.createdAt.isSmallerThanValue(updateAllBefore),
      //         ),
      //         innerJoin(
      //           eventMessageTable,
      //           eventMessageTable.eventReference
      //                   .equalsExp(conversationMessageTable.messageEventReference) &
      //               eventMessageTable.createdAt.isSmallerThanValue(updateAllBefore),
      //         ),
      //       ]))
      //     .get();

      // Batch update the status of all previous messages to read
      // await batch((batch) {
      //   for (final row in unreadResults) {
      //     batch.update(
      //       messageStatusTable,
      //       const MessageStatusTableCompanion(status: Value(MessageDeliveryStatus.read)),
      //       where: (table) =>
      //           table.messageEventReference.equalsValue(row.messageEventReference) &
      //           table.masterPubkey.equals(row.masterPubkey),
      //     );
      //   }
      // });
    } else {
      // Fetch the existing status for the given pubkey and eventReference
      final existingStatus = await (select(messageStatusTable)
            ..where((table) => table.pubkey.equals(pubkey))
            ..where((table) => table.masterPubkey.equals(masterPubkey))
            ..where((table) => table.messageEventReference.equalsValue(messageEventReference)))
          .getSingleOrNull();

      if (existingStatus == null) {
        // Insert a new row if no existing status is found
        await into(messageStatusTable).insert(
          MessageStatusTableCompanion.insert(
            status: status,
            pubkey: pubkey,
            messageEventReference: messageEventReference,
            masterPubkey: masterPubkey,
          ),
        );
      } else if (status.index > existingStatus.status.index) {
        // Update the row if the new status has a higher priority
        await (update(messageStatusTable)
              ..where((table) => table.pubkey.equals(pubkey))
              ..where((table) => table.messageEventReference.equalsValue(messageEventReference))
              ..where((table) => table.masterPubkey.equals(masterPubkey)))
            .write(
          MessageStatusTableCompanion(
            status: Value(status),
          ),
        );
      }
    }
  }

  Stream<MessageDeliveryStatus> messageStatus({
    required EventReference eventReference,
    required String currentUserMasterPubkey,
  }) {
    return (select(messageStatusTable)
          ..where((table) => table.messageEventReference.equalsValue(eventReference)))
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

  Future<List<String>> getFailedParticipants({
    required EventReference eventReference,
  }) async {
    final existingRows = await (select(messageStatusTable)
          ..where((table) => table.messageEventReference.equalsValue(eventReference))
          ..where((table) => table.status.equals(MessageDeliveryStatus.failed.index)))
        .get();

    return existingRows.map((row) => row.masterPubkey).toList();
  }

  Future<MessageDeliveryStatus?> checkMessageStatus({
    required EventReference eventReference,
    required String masterPubkey,
  }) async {
    final existingDeviceStatuses = await (select(messageStatusTable)
          ..where((table) => table.messageEventReference.equalsValue(eventReference))
          ..where((table) => table.masterPubkey.equals(masterPubkey)))
        .get();

    return existingDeviceStatuses.isNotEmpty
        ? existingDeviceStatuses
            .map((row) => row.status)
            .reduce((a, b) => a.index > b.index ? a : b)
        : null;
  }

  Future<void> reinitializeFailedStatus({
    required EventReference eventReference,
  }) async {
    await (update(messageStatusTable)
          ..where((table) => table.messageEventReference.equalsValue(eventReference))
          ..where((table) => table.status.equals(MessageDeliveryStatus.failed.index)))
        .write(
      const MessageStatusTableCompanion(
        status: Value(MessageDeliveryStatus.created),
      ),
    );
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
