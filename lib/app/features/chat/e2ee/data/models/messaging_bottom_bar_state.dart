// SPDX-License-Identifier: ice License 1.0

enum MessagingBottomBarState {
  text,
  hasText,
  voice,
  voiceLocked,
  voicePaused,
  more;

  bool get isText => this == MessagingBottomBarState.text;
  bool get isHasText => this == MessagingBottomBarState.hasText;
  bool get isVoice => this == MessagingBottomBarState.voice;
  bool get isVoiceLocked => this == MessagingBottomBarState.voiceLocked;
  bool get isVoicePaused => this == MessagingBottomBarState.voicePaused;
  bool get isMore => this == MessagingBottomBarState.more;
}
