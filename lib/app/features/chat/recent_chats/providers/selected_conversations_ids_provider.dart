// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversations_ids_provider.g.dart';

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
