// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_history_provider.freezed.dart';
part 'feed_search_history_provider.g.dart';

@freezed
class FeedSearchHistoryState with _$FeedSearchHistoryState {
  const factory FeedSearchHistoryState({
    required List<String> userIds,
    required List<String> queries,
  }) = _FeedSearchHistoryState;
}

@riverpod
class FeedSearchHistory extends _$FeedSearchHistory {
  static const String _userIdsStoreKey = 'FeedSearchHistory:userIds';
  static const String _queriesStoreKey = 'FeedSearchHistory:queries';

  @override
  FeedSearchHistoryState build() {
    final userId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    final storedUserIds = userPreferencesService.getValue<List<String>>(_userIdsStoreKey) ?? [];
    final storedQueries = userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [];

    return FeedSearchHistoryState(userIds: storedUserIds, queries: storedQueries);
  }

  Future<void> addUserIdToTheHistory(String userId) async {
    if (!state.userIds.contains(userId)) {
      final newUserIds = [userId, ...state.userIds];

      final currentUserId = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      await userPreferencesService.setValue<List<String>>(_userIdsStoreKey, newUserIds);

      state = state.copyWith(userIds: newUserIds);
    }
  }

  Future<void> addQueryToTheHistory(String query) async {
    if (!state.queries.contains(query)) {
      final newQueries = [query, ...state.queries];

      final currentUserId = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      await userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);

      state = state.copyWith(queries: newQueries);
    }
  }

  Future<void> clear() async {
    final currentUserId = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: currentUserId));
    await Future.wait([
      userPreferencesService.remove(_userIdsStoreKey),
      userPreferencesService.remove(_queriesStoreKey),
    ]);
    state = const FeedSearchHistoryState(queries: [], userIds: []);
  }
}
