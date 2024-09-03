import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/feed_filter.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_current_filter_provider.freezed.dart';
part 'feed_current_filter_provider.g.dart';

@Freezed(copyWith: true, equal: true)
class FeedFiltersState with _$FeedFiltersState {
  const FeedFiltersState._();

  const factory FeedFiltersState({
    required FeedCategory category,
    required FeedFilter filter,
  }) = _FeedFiltersState;

  static const FeedCategory defaultCategory = FeedCategory.feed;
  static const FeedFilter defaultFilter = FeedFilter.forYou;
}

@riverpod
class FeedCurrentFilter extends _$FeedCurrentFilter {
  static const _feedFilterCategoryKey = 'feed_filter_category';
  static const _feedFilterFilterKey = 'feed_filter_filter';

  @override
  FeedFiltersState build() {
    _listenChanges();

    final savedState = _loadSavedState();

    return savedState;
  }

  set filter(FeedFilter filter) {
    state = state.copyWith(filter: filter);
  }

  set category(FeedCategory category) {
    state = state.copyWith(category: category);
  }

  void _listenChanges() {
    ref.listenSelf((_, next) => _saveState(next));
  }

  void _saveState(FeedFiltersState state) {
    final userId = ref.read(userDataNotifierProvider).id;
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: userId));

    userPreferencesService.setEnum(_feedFilterCategoryKey, state.category);
    userPreferencesService.setEnum(_feedFilterFilterKey, state.filter);
  }

  FeedFiltersState _loadSavedState() {
    final userId = ref.watch(userDataNotifierProvider).id;
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    final category = userPreferencesService.getEnum(_feedFilterCategoryKey, FeedCategory.values);
    final filter = userPreferencesService.getEnum(_feedFilterFilterKey, FeedFilter.values);

    return FeedFiltersState(
      category: category ?? FeedFiltersState.defaultCategory,
      filter: filter ?? FeedFiltersState.defaultFilter,
    );
  }
}
