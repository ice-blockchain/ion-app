// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_current_filter_provider.m.freezed.dart';
part 'feed_current_filter_provider.m.g.dart';

@freezed
class FeedFiltersState with _$FeedFiltersState {
  const factory FeedFiltersState({
    required FeedCategory category,
    required FeedFilter filter,
  }) = _FeedFiltersState;
  const FeedFiltersState._();

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
    listenSelf((_, next) => _saveState(next));
  }

  void _saveState(FeedFiltersState state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return;
    }

    ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
      ..setEnum(_feedFilterCategoryKey, state.category)
      ..setEnum(_feedFilterFilterKey, state.filter);
  }

  FeedFiltersState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return const FeedFiltersState(
        category: FeedFiltersState.defaultCategory,
        filter: FeedFiltersState.defaultFilter,
      );
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final category = userPreferencesService.getEnum(_feedFilterCategoryKey, FeedCategory.values);
    final filter = userPreferencesService.getEnum(_feedFilterFilterKey, FeedFilter.values);

    return FeedFiltersState(
      category: category ?? FeedFiltersState.defaultCategory,
      filter: filter ?? FeedFiltersState.defaultFilter,
    );
  }
}
