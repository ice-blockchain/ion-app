// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_messages_provider.c.g.dart';

@riverpod
class ConversationMessages extends _$ConversationMessages {
  @override
  Stream<Map<DateTime, List<EventMessage>>> build(String conversationId, ConversationType type) {
    final stream = ref.watch(conversationMessageDaoProvider).getMessages(conversationId);

    final subscription = stream.listen((event) async {
      if (type == ConversationType.community) return;

      final lastMessage = event.entries.last.value.last;
      await (await ref.watch(sendE2eeMessageServiceProvider.future))
          .sendMessageStatus(lastMessage, MessageDeliveryStatus.read);
    });

    ref.onDispose(subscription.cancel);

    return stream;
  }
}
