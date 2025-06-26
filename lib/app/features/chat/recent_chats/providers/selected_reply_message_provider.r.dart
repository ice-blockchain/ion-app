// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/message_list_item.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_reply_message_provider.r.g.dart';

@Riverpod()
class SelectedReplyMessage extends _$SelectedReplyMessage {
  @override
  ChatMessageInfoItem? build() {
    return null;
  }

  set selectedReplyMessage(ChatMessageInfoItem messageItem) {
    state = messageItem;
  }

  void clear() {
    state = null;
  }
}
