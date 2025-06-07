// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_state.c.freezed.dart';

@freezed
class EmojiState with _$EmojiState {
  const factory EmojiState({
    String? selectedEmoji,
    @Default(false) bool showNotification,
  }) = _EmojiState;
}
