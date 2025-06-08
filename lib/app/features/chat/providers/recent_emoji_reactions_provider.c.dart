// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_emoji_reactions_provider.c.g.dart';

@riverpod
class RecentEmojiReactions extends _$RecentEmojiReactions {
  static const String _storeKey = 'RecentEmojiReactions:emojis';
  static const List<String> _defaultEmojis = ['👍', '🔥', '😍', '👎', '👋'];

  @override
  List<String> build() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    return userPreferencesService.getValue<List<String>>(_storeKey) ?? _defaultEmojis;
  }

  Future<void> addEmoji(String emoji) async {
    if (emoji.isEmpty) return;

    final currentEmojis = [...state]..remove(emoji);

    final newEmojis = [emoji, ...currentEmojis].take(5).toList();

    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    await userPreferencesService.setValue<List<String>>(_storeKey, newEmojis);
  }
}
