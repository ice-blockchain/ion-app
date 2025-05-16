// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_status_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_messages_provider.c.g.dart';

@riverpod
class ConversationMessages extends _$ConversationMessages {
  @override
  Stream<Map<DateTime, List<EventMessage>>> build(String conversationId, ConversationType type) {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentUserMasterPubkey == null) {
      return const Stream.empty();
    }

    final stream = ref.watch(conversationMessageDaoProvider).getMessages(conversationId);

    final subscription = stream.listen((event) async {
      if (type == ConversationType.community) return;

      final lastMessage = event.entries.lastOrNull?.value.first;

      if (lastMessage == null) return;

      // There is no other options rather send read status for the last message

      if (lastMessage.masterPubkey == currentUserMasterPubkey) return;
      final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(lastMessage);
      final status = await ref.watch(conversationMessageDataDaoProvider).checkMessageStatus(
            eventReference: entity.toEventReference(),
            masterPubkey: currentUserMasterPubkey,
          );
      if (status == MessageDeliveryStatus.read) return;
      await (await ref.watch(sendE2eeMessageStatusServiceProvider.future)).sendMessageStatus(
        messageEventMessage: lastMessage,
        status: MessageDeliveryStatus.read,
      );
    });

    ref.onDispose(subscription.cancel);

    return stream;
  }
}
