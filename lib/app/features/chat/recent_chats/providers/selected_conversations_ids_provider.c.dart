// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversations_ids_provider.c.g.dart';

@Riverpod()
class SelectedConversationsIds extends _$SelectedConversationsIds {
  @override
  List<ConversationEntity> build() {
    return [];
  }

  void toggle(List<ConversationEntity> conversation) {
    if (Set<ConversationEntity>.from(state).containsAll(conversation)) {
      state = List.from(state)..removeWhere((element) => conversation.contains(element));
    } else {
      state = List.from(state)..addAll(conversation);
    }
  }

  void clear() {
    state = [];
  }
}
