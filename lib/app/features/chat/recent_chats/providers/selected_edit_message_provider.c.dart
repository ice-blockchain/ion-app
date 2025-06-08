// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/e2ee/data/models/message_list_item.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_edit_message_provider.c.g.dart';

@Riverpod()
class SelectedEditMessage extends _$SelectedEditMessage {
  @override
  ChatMessageInfoItem? build() {
    return null;
  }

  set selectedEditMessage(ChatMessageInfoItem messageItem) {
    state = messageItem;
  }

  void clear() {
    state = null;
  }
}
