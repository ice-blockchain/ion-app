// SPDX-License-Identifier: ice License 1.0

// import 'package:drift/drift.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ion/app/features/chat/database/conversation_database.c.dart';
// import 'package:nostr_dart/nostr_dart.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'conversation_database_service.c.g.dart';

// @Riverpod(keepAlive: true)
// ConversationDatabaseService conversationDatabaseService(Ref ref) =>
//     ConversationDatabaseService(ref.watch(conversationDatabaseProvider));

// class ConversationDatabaseService {
//   ConversationDatabaseService(this._db);

//   final ConversationDatabase _db;

//   //add conversation
//   Future<void> add(List<EventMessage> conversations) async {
//     final data = conversations.map(EventMessageTableData.fromEventMessage);

//     await _db.batch(
//       (b) {
//         b.insertAll(_db.nonEncryptedConversationTable, data, mode: InsertMode.insertOrReplace);
//       },
//     );
//   }

//   //watch conversations
//   Stream<List<EventMessage>> watchConversations() {
//     return _db.select(_db.nonEncryptedConversationTable).map((e) => e.toEventMessage()).watch();
//   }

//   //get conversations
//   Future<List<EventMessage>> getAll() {
//     return _db.select(_db.nonEncryptedConversationTable).map((e) => e.toEventMessage()).get();
//   }

//   //get conversation by id
//   Future<EventMessageTableData?> getById(String id) async {
//     return (_db.select(_db.nonEncryptedConversationTable)
//           ..where((conversation) => conversation.id.equals(id)))
//         .getSingle();
//   }
// }
