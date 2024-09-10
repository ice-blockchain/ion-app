import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_history_provider.g.dart';
part 'feed_search_history_provider.freezed.dart';

@Freezed(copyWith: true)
class FeedSearchHistoryState with _$FeedSearchHistoryState {
  const factory FeedSearchHistoryState({
    required List<String> userIds,
    required List<String> queries,
  }) = _FeedSearchHistoryState;
}

@riverpod
class FeedSearchHistory extends _$FeedSearchHistory {
  static String _userIdsStoreKey = 'FeedSearchHistory:userIds';
  static String _queriesStoreKey = 'FeedSearchHistory:queries';

  @override
  FeedSearchHistoryState build() {
    final userId = ref.watch(currentUserIdSelectorProvider);
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    return FeedSearchHistoryState(
      userIds: userPreferencesService.getValue<List<String>>(_userIdsStoreKey) ?? [],
      queries: userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [],
    );
  }

  Future<bool> addUserToTheHistory(String userId) async {
    if (!state.userIds.contains(userId)) {
      final newUserIds = [...state.userIds, userId];
      final currentUserId = ref.read(currentUserIdSelectorProvider);
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      state = state.copyWith(userIds: newUserIds);
      return userPreferencesService.setValue<List<String>>(_userIdsStoreKey, newUserIds);
    }
    return false;
  }

  Future<bool> addQueryToTheHistory(String query) async {
    if (!state.queries.contains(query)) {
      final newQueries = [...state.queries, query];
      final currentUserId = ref.read(currentUserIdSelectorProvider);
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      state = state.copyWith(queries: newQueries);
      return userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);
    }
    return false;
  }
}
