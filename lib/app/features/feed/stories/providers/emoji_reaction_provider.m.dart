// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emoji_reaction_provider.m.g.dart';
part 'emoji_reaction_provider.m.freezed.dart';

@freezed
class EmojiState with _$EmojiState {
  const factory EmojiState({
    String? selectedEmoji,
    @Default(false) bool showNotification,
  }) = _EmojiState;
}

@riverpod
class EmojiReactionsController extends _$EmojiReactionsController {
  @override
  EmojiState build() => const EmojiState();

  void showReaction(String emoji) {
    state = state.copyWith(
      selectedEmoji: emoji,
      showNotification: true,
    );
  }

  void hideNotification() {
    state = state.copyWith(
      selectedEmoji: null,
      showNotification: false,
    );
  }
}
