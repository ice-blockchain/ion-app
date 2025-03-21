// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_message_provider.c.g.dart';

@Riverpod()
class SelectedMessage extends _$SelectedMessage {
  
  @override
  MessageListItem? build() {
    return null;
  }

  void selectMessage(MessageListItem messageItem) {
    state = messageItem;
  }

  void clear() {
    state = null;
  }
}
