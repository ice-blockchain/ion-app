import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/feed_filter.dart';
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

  factory FeedFiltersState.initial() => const FeedFiltersState(
        category: FeedCategory.feed,
        filter: FeedFilter.forYou,
      );

  bool get isDefault => category == FeedCategory.feed && filter == FeedFilter.forYou;
}

@riverpod
class FeedCurrentFilter extends _$FeedCurrentFilter {
  @override
  FeedFiltersState build() {
    return FeedFiltersState.initial();
  }

  set filter(FeedFilter filter) {
    state = state.copyWith(filter: filter);
  }

  set category(FeedCategory category) {
    state = state.copyWith(category: category);
  }
}
