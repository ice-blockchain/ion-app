// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_edit_mode_provider.g.dart';

@Riverpod()
class Conversations extends _$Conversations {
  @override
  Future<List<RecentChatDataModel>> build() {
    return Future.delayed(const Duration(seconds: 2), () {
      return mockConversationData;
    });
  }
}

@Riverpod()
class ConversationsEditMode extends _$ConversationsEditMode {
  @override
  bool build() {
    return false;
  }

  set editMode(bool editMode) {
    ref.read(selectedConversationsIdsProvider.notifier).clear();
    state = editMode;
  }
}

@Riverpod()
class SelectedConversationsIds extends _$SelectedConversationsIds {
  @override
  List<String> build() {
    return [];
  }

  void toggle(String conversationId) {
    if (state.contains(conversationId)) {
      state = List.from(state)..remove(conversationId);
    } else {
      state = List.from(state)..add(conversationId);
    }
  }

  void clear() {
    state = [];
  }
}
