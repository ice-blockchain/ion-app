// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/message_list_item.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_edit_message_provider.r.g.dart';

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
