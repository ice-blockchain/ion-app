import 'package:ion/app/features/chat/services/conversation_db_service.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@riverpod
class Conversations extends _$Conversations {
  @override
  FutureOr<List<EventMessage>> build() async {
    final stream = ref.watch(conversationsDBServiceProvider).watchConversations().listen((event) {
      state = AsyncValue.data(event);
    });

    ref.onDispose(stream.cancel);

    return await _getConversations();
  }

  Future<List<EventMessage>> _getConversations() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final conversations = await ref.watch(conversationsDBServiceProvider).getAll();

      return conversations;
    });

    return state.requireValue;
  }
}
