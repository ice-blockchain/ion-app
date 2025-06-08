// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/search/data/models/feed_search_filters_state.c.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filters_provider.c.g.dart';

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
