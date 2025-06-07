// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/stories/data/models/emoji_state.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'emoji_reaction_provider.c.g.dart';

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
