// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversations_ids_provider.r.g.dart';

@Riverpod()
class SelectedConversations extends _$SelectedConversations {
  @override
  List<ConversationListItem> build() {
    return [];
  }

  void toggle(ConversationListItem conversation) {
    if (state.contains(conversation)) {
      state = state.where((element) => element != conversation).toList();
    } else {
      state = [...state, conversation];
    }
  }

  void toggleAll(List<ConversationListItem> conversations) {
    for (final conversation in conversations) {
      toggle(conversation);
    }
  }

  void clear() {
    state = [];
  }
}
