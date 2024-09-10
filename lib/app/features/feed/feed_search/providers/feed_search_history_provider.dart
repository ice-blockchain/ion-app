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
  static String _userIdStoreKey = '___u';
  static String _queriesStoreKey = '___q';

  @override
  FeedSearchHistoryState build() {
    final userId = ref.watch(currentUserIdSelectorProvider);
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    return FeedSearchHistoryState(
      userIds: userPreferencesService.getValue<List<String>>(_userIdStoreKey) ?? [],
      queries: userPreferencesService.getValue<List<String>>(_queriesStoreKey) ?? [],
    );
  }
}
