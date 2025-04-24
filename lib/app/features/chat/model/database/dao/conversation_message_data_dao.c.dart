// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageDataDao conversationMessageDataDao(Ref ref) =>
    ConversationMessageDataDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [MessageStatusTable],
)
class ConversationMessageDataDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageDataDaoMixin {
  ConversationMessageDataDao(super.db);

  Future<void> add({
    required String pubkey,
    required String sharedId,
    required String masterPubkey,
    required MessageDeliveryStatus status,
  }) async {
    print('Adding message status: $pubkey, $sharedId, $masterPubkey, $status');
    // Check if the status is already present in the database for given pubkey
    // (user device) and sharedId (message id)
    final existingStatus = await (select(messageStatusTable)
          ..where((table) => table.pubkey.equals(pubkey))
          ..where((table) => table.sharedId.equals(sharedId))
          ..limit(1))
        .getSingleOrNull();

    // If the status is already present and the new status is higher than the
    // existing status, update the existing status
    if (existingStatus != null && status.index > existingStatus.status.index) {
      await (update(messageStatusTable)
            ..where((table) => table.pubkey.equals(pubkey))
            ..where((table) => table.sharedId.equals(sharedId)))
          .write(
        MessageStatusTableCompanion(
          pubkey: Value(pubkey),
          status: Value(status),
          sharedId: Value(sharedId),
          masterPubkey: Value(masterPubkey),
        ),
      );
      // If the status is not present, insert a new row
    } else {
      await into(messageStatusTable).insert(
        MessageStatusTableCompanion(
          status: Value(status),
          pubkey: Value(pubkey),
          sharedId: Value(sharedId),
          masterPubkey: Value(masterPubkey),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  Stream<MessageDeliveryStatus> messageStatus({
    required String sharedId,
    required String masterPubkey,
  }) {
    return (select(messageStatusTable)
          ..where((table) => table.sharedId.equals(sharedId))
          ..where((table) => table.pubkey.equals(masterPubkey)))
        .watch()
        .map((rows) {
      if (rows.every((row) => row.status == MessageDeliveryStatus.deleted)) {
        return MessageDeliveryStatus.deleted;
      } else
      // First check if any of the rows are failed
      if (rows.any((row) => row.status == MessageDeliveryStatus.failed)) {
        return MessageDeliveryStatus.failed;
      } else
      // Check if any row (user device) have read status which we consider as read
      if (rows.any((row) => row.status == MessageDeliveryStatus.read)) {
        return MessageDeliveryStatus.read;
      } else
      // Check if any row (user device) have received status which we consider as received
      if (rows.any((row) => row.status.index >= MessageDeliveryStatus.received.index)) {
        return MessageDeliveryStatus.received;
      } else
      // Check if any row (user device) have higher status then created
      if (rows.any((row) => row.status.index > MessageDeliveryStatus.created.index)) {
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
