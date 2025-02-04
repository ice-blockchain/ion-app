import 'package:ion/app/features/chat/database/repositories/conversation_db_repository.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@riverpod
class Conversations extends _$Conversations {
  @override
  FutureOr<List<ConversationListItem>> build() async {
    final stream = ref.watch(conversationDbRepositoryProvider).watchAll().listen((event) {
      state = AsyncValue.data(event);
    });

    ref.onDispose(stream.cancel);

    return await _getConversations();
  }

  Future<List<ConversationListItem>> _getConversations() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final conversations = await ref.watch(conversationDbRepositoryProvider).getAll();

      return conversations;
    });

    return state.requireValue;
  }
}
