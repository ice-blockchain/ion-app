// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/search/data/models/chat_search_history_state.c.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_search_history_provider.c.g.dart';

@riverpod
class ChatSearchHistory extends _$ChatSearchHistory {
  static const String _pubKeysStoreKey = 'ChatSearchHistory:pubKeys';
  static const String _queriesStoreKey = 'ChatSearchHistory:queries';

  @override
  ChatSearchHistoryState build() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final storedUserIds = userPreferencesService.getValue<List<String>>(_pubKeysStoreKey) ?? [];
    final storedQueries = userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [];

    return ChatSearchHistoryState(pubKeys: storedUserIds, queries: storedQueries);
  }

  Future<void> addUserIdToTheHistory(String pubkey) async {
    if (!state.pubKeys.contains(pubkey)) {
      final newUserIds = [pubkey, ...state.pubKeys];

      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
      await userPreferencesService.setValue<List<String>>(_pubKeysStoreKey, newUserIds);

      state = state.copyWith(pubKeys: newUserIds);
    }
  }

  Future<void> addQueryToTheHistory(String query) async {
    if (!state.queries.contains(query)) {
      final newQueries = [query, ...state.queries];

      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
      await userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);

      state = state.copyWith(queries: newQueries);
    }
  }

  Future<void> clear() async {
    final currentUserId = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: currentUserId));
    await Future.wait([
      userPreferencesService.remove(_pubKeysStoreKey),
      userPreferencesService.remove(_queriesStoreKey),
    ]);
    state = const ChatSearchHistoryState(queries: [], pubKeys: []);
  }
}
