// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/models/messaging_bottom_bar_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_bottom_bar_state_provider.g.dart';

@Riverpod(keepAlive: true)
class MessaingBottomBarActiveState extends _$MessaingBottomBarActiveState {
  @override
  MessagingBottomBarState build() {
    return MessagingBottomBarState.text;
  }

  void setVoice() {
    state = MessagingBottomBarState.voice;
  }

  void setText() {
    state = MessagingBottomBarState.text;
  }

  void setMore() {
    state = MessagingBottomBarState.more;
  }
}
