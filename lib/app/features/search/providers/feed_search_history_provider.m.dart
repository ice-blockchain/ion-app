// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_history_provider.m.freezed.dart';
part 'feed_search_history_provider.m.g.dart';

@freezed
class FeedSearchHistoryState with _$FeedSearchHistoryState {
  const factory FeedSearchHistoryState({
    required List<String> pubKeys,
    required List<String> queries,
  }) = _FeedSearchHistoryState;
}

@riverpod
class FeedSearchHistory extends _$FeedSearchHistory {
  static const String _pubKeysStoreKey = 'FeedSearchHistory:pubKeys';
  static const String _queriesStoreKey = 'FeedSearchHistory:queries';

  @override
  FeedSearchHistoryState build() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final storedUserIds = userPreferencesService.getValue<List<String>>(_pubKeysStoreKey) ?? [];
    final storedQueries = userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [];

    return FeedSearchHistoryState(pubKeys: storedUserIds, queries: storedQueries);
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
    if (state.queries.firstOrNull != query) {
      final newQueries = [query, ...state.queries];

      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
      await userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);

      state = state.copyWith(queries: newQueries);
    }
  }

  Future<void> clear() async {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    await Future.wait([
      userPreferencesService.remove(_pubKeysStoreKey),
      userPreferencesService.remove(_queriesStoreKey),
    ]);
    state = const FeedSearchHistoryState(queries: [], pubKeys: []);
  }
}
