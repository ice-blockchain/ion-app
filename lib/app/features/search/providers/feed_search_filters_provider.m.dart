// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filters_provider.m.freezed.dart';
part 'feed_search_filters_provider.m.g.dart';

@freezed
class FeedSearchFiltersState with _$FeedSearchFiltersState {
  const factory FeedSearchFiltersState({
    required Map<FeedCategory, bool> categories,
    required FeedSearchSource source,
  }) = _FeedSearchFiltersState;

  factory FeedSearchFiltersState.initial() {
    return const FeedSearchFiltersState(
      source: FeedSearchSource.anyone,
      categories: {FeedCategory.feed: true, FeedCategory.videos: true, FeedCategory.articles: true},
    );
  }

  factory FeedSearchFiltersState.fromJson(Map<String, dynamic> json) =>
      _$FeedSearchFiltersStateFromJson(json);
}

@riverpod
class FeedSearchFilter extends _$FeedSearchFilter {
  static const _feedSearchFilterKey = '_FeedSearchFilter';

  @override
  FeedSearchFiltersState build() {
    _listenChanges();

    final savedState = _loadSavedState();

    return savedState;
  }

  set filterSource(FeedSearchSource source) {
    state = state.copyWith(source: source);
  }

  set filterCategories(Map<FeedCategory, bool> categories) {
    state = state.copyWith(categories: categories);
  }

  set newState(FeedSearchFiltersState newState) {
    state = newState;
  }

  void _listenChanges() {
    listenSelf((_, next) => _saveState(next));
  }

  void _saveState(FeedSearchFiltersState state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_feedSearchFilterKey, jsonEncode(state.toJson()));
  }

  FeedSearchFiltersState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final savedStateJson = userPreferencesService.getValue<String>(_feedSearchFilterKey);

    if (savedStateJson != null) {
      try {
        return FeedSearchFiltersState.fromJson(jsonDecode(savedStateJson) as Map<String, dynamic>);
      } catch (error, stackTrace) {
        Logger.error(error, stackTrace: stackTrace);
      }
    }

    return FeedSearchFiltersState.initial();
  }
}
