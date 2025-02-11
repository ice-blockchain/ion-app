import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exist_chat_conversation_id_provider.c.g.dart';

@riverpod
Future<String?> existChatConversationId(Ref ref, String receiverMasterPubKey) async {
  return ref.watch(conversationDaoProvider).getExistOnetOneConversationId(receiverMasterPubKey);
}
