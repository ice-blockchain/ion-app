// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversations_ids_provider.c.g.dart';

@Riverpod()
class SelectedConversationsIds extends _$SelectedConversationsIds {
  @override
  List<EE2EConversationEntity> build() {
    return [];
  }

  void toggle(List<EE2EConversationEntity> conversationData) {
    if (Set<EE2EConversationEntity>.from(state).containsAll(conversationData)) {
      state = List.from(state)..removeWhere((element) => conversationData.contains(element));
    } else {
      state = List.from(state)..addAll(conversationData);
    }
  }

  void clear() {
    state = [];
  }
}
