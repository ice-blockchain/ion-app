// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/features/chat/model/message_delivery_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_message_status_provider.c.g.dart';

@riverpod
class ChatMessageStatus extends _$ChatMessageStatus {
  @override
  Future<MessageDeliveryStatus> build(String messageId) async {
    final messageStatusSubscription = ref
        .watch(conversationsDBServiceProvider)
        .watchMessageDeliveryStatus(messageId)
        .listen((statuses) async {
      final messageStatus = _mapStatus(statuses);

      state = AsyncValue.data(messageStatus);
    });

    ref.onDispose(messageStatusSubscription.cancel);

    state = const AsyncValue.loading();

    final statusesMap =
        await ref.watch(conversationsDBServiceProvider).getMessageDeliveryStatuses(messageId);

    return _mapStatus(statusesMap);
  }

  MessageDeliveryStatus _mapStatus(Map<String, MessageDeliveryStatus> statusesMap) {
    final statuses = statusesMap.values;

    if (statuses.contains(MessageDeliveryStatus.failed)) {
      return MessageDeliveryStatus.failed;
    }

    if (statuses.every((status) => status == MessageDeliveryStatus.sent)) {
      return MessageDeliveryStatus.sent;
    }

    return MessageDeliveryStatus.created;
  }
}
