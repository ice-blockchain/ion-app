// SPDX-License-Identifier: ice License 1.0

enum MessagingBottomBarState {
  text,
  voice,
  more;

  bool get isText => this == MessagingBottomBarState.text;
  bool get isVoice => this == MessagingBottomBarState.voice;
  bool get isMore => this == MessagingBottomBarState.more;
}
