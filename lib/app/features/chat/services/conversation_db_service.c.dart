import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/database/conversation_database.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_db_service.c.g.dart';

@Riverpod(keepAlive: true)
ConversationsDBService conversationsDBService(Ref ref) =>
    ConversationsDBService(ref.watch(conversationDatabaseProvider));

class ConversationsDBService {
  ConversationsDBService(this._db);

  final ConversationDatabase _db;

  //add conversation
  Future<void> add(List<EventMessage> conversations) async {
    final data = conversations.map(EventMessageTableData.fromEventMessage);

    await _db.batch(
      (b) {
        b.insertAll(_db.conversationTable, data, mode: InsertMode.insertOrReplace);
      },
    );
  }

  //watch conversations
  Stream<List<EventMessage>> watchConversations() {
    return _db.select(_db.conversationTable).map((e) => e.toEventMessage()).watch();
  }

  //get conversations
  Future<List<EventMessage>> getAll() {
    return _db.select(_db.conversationTable).map((e) => e.toEventMessage()).get();
  }

  //get conversation by id
  Future<EventMessageTableData?> getById(String id) async {
    return (_db.select(_db.conversationTable)..where((conversation) => conversation.id.equals(id)))
        .getSingle();
  }
}
