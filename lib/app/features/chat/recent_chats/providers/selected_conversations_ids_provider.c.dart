// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversations_ids_provider.c.g.dart';

@Riverpod()
class SelectedConversationsIds extends _$SelectedConversationsIds {
  @override
  List<String> build() {
    return [];
  }

  void toggle(String conversationId) {
    if (state.contains(conversationId)) {
      state = state.where((element) => element != conversationId).toList();
    } else {
      state = [...state, conversationId];
    }
  }

  void clear() {
    state = [];
  }
}
