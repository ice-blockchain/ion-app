import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@riverpod
class Conversations extends _$Conversations {
  @override
  Stream<List<ConversationListItem>> build() {
    return ref.watch(conversationTableDaoProvider).watch();
  }
}
