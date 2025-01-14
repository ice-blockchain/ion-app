// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/channel_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<PrivateDirectMessageEntity>> build() async {
    final conversationSubscription = ref
        .read(conversationsDBServiceProvider)
        .watchConversations()
        .listen((conversationsEventMessages) async {
      final data =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      state = AsyncValue.data(data);
    });

    ref.onDispose(conversationSubscription.cancel);

    state = const AsyncValue.loading();
    try {
      final database = ref.read(conversationsDBServiceProvider);
      final conversationsEventMessages = await database.getAllConversations();

      final conversationsList =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();
      state = AsyncValue.data(conversationsList);
      return conversationsList;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void addChannelConversation(ChannelData channelData) {
    update((currentData) {
      final newConversation = PrivateDirectMessageEntity(
        id: 'id',
        pubkey: 'pubKey',
        createdAt: DateTime.now(),
        data: const PrivateDirectMessageData(content: [], media: {}),
      );
      final newData = [
        newConversation,
        ...currentData,
      ];
      return List<PrivateDirectMessageEntity>.unmodifiable(newData);
    });
  }
}
