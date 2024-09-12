import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/mocked_search_users.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_history_store_provider.g.dart';
part 'feed_search_history_store_provider.freezed.dart';

@Freezed(copyWith: true)
class FeedSearchHistoryState with _$FeedSearchHistoryState {
  const factory FeedSearchHistoryState({
    required List<FeedSearchUser> users,
    required List<String> queries,
  }) = _FeedSearchHistoryState;
}

@riverpod
class FeedSearchHistoryStore extends _$FeedSearchHistoryStore {
  static String _userIdsStoreKey = 'FeedSearchHistory:userIds';
  static String _queriesStoreKey = 'FeedSearchHistory:queries';

  @override
  Future<FeedSearchHistoryState> build() async {
    final userId = ref.watch(currentUserIdSelectorProvider);
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    final storedUserIds = userPreferencesService.getValue<List<String>>(_userIdsStoreKey);
    final storedQueries = userPreferencesService.getValue<List<String>>(_queriesStoreKey);

    final users = storedUserIds != null && storedUserIds.isNotEmpty
        ? await Future(() async {
            await Future<void>.delayed(Duration(seconds: 1));
            return storedUserIds
                .map((userId) => feedSearchUsers.firstWhere((user) => user.id == userId))
                .toList();
          })
        : <FeedSearchUser>[];

    return FeedSearchHistoryState(users: users, queries: storedQueries ?? []);
  }

  Future<void> addUserToTheHistory(FeedSearchUser user) async {
    final stateValue = state.value;
    if (stateValue != null && !stateValue.users.any((u) => u.id == user.id)) {
      final newUsers = [...stateValue.users, user];
      final newUserIds = newUsers.map((u) => u.id).toList();

      final currentUserId = ref.read(currentUserIdSelectorProvider);
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      await userPreferencesService.setValue<List<String>>(_userIdsStoreKey, newUserIds);

      state = AsyncValue.data(stateValue.copyWith(users: newUsers));
    }
  }

  Future<void> addQueryToTheHistory(String query) async {
    final stateValue = state.value;
    if (stateValue != null && !stateValue.queries.contains(query)) {
      final newQueries = [...stateValue.queries, query];

      final currentUserId = ref.read(currentUserIdSelectorProvider);
      final userPreferencesService =
          ref.read(userPreferencesServiceProvider(userId: currentUserId));
      await userPreferencesService.setValue<List<String>>(_queriesStoreKey, newQueries);

      state = AsyncValue.data(stateValue.copyWith(queries: newQueries));
    }
  }

  Future<void> clear() async {
    final currentUserId = ref.read(currentUserIdSelectorProvider);
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: currentUserId));
    await Future.wait([
      userPreferencesService.remove(_userIdsStoreKey),
      userPreferencesService.remove(_queriesStoreKey),
    ]);
    state = AsyncValue.data(FeedSearchHistoryState(queries: [], users: []));
  }
}
