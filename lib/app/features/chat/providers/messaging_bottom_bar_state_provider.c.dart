// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/e2ee/data/models/messaging_bottom_bar_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_bottom_bar_state_provider.c.g.dart';

@riverpod
class MessagingBottomBarActiveState extends _$MessagingBottomBarActiveState {
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

  void setHasText() {
    state = MessagingBottomBarState.hasText;
  }

  void setVoiceLocked() {
    state = MessagingBottomBarState.voiceLocked;
  }

  void setVoicePaused() {
    state = MessagingBottomBarState.voicePaused;
  }
}
