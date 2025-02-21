// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filters_provider.c.freezed.dart';
part 'feed_search_filters_provider.c.g.dart';

@freezed
class FeedSearchFiltersState with _$FeedSearchFiltersState {
  const factory FeedSearchFiltersState({
    required List<Language> languages,
    required FeedSearchSource source,
  }) = _FeedSearchFiltersState;

  factory FeedSearchFiltersState.initial() {
    return const FeedSearchFiltersState(
      source: FeedSearchSource.anyone,
      languages: [Language.english],
    );
  }
}

@riverpod
class FeedSearchFilter extends _$FeedSearchFilter {
  static const _feedSearchSourceFilterKey = 'FeedSearchFilter:source';
  static const _feedSearchLanguagesFilterKey = 'FeedSearchFilter:languages';

  @override
  FeedSearchFiltersState build() {
    _listenChanges();

    final savedState = _loadSavedState();

    return savedState;
  }

  set filterSource(FeedSearchSource source) {
    state = state.copyWith(source: source);
  }

  set languages(List<Language> languages) {
    state = state.copyWith(languages: languages);
  }

  set newState(FeedSearchFiltersState newState) {
    state = newState;
  }

  void _listenChanges() {
    listenSelf((_, next) => _saveState(next));
  }

  void _saveState(FeedSearchFiltersState state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
      ..setEnum(_feedSearchSourceFilterKey, state.source)
      ..setValue<List<String>>(
        _feedSearchLanguagesFilterKey,
        state.languages.map((lang) => lang.isoCode).toList(),
      );
  }

  FeedSearchFiltersState _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final source =
        userPreferencesService.getEnum(_feedSearchSourceFilterKey, FeedSearchSource.values);
    final languages = userPreferencesService
        .getValue<List<String>>(_feedSearchLanguagesFilterKey)
        ?.map(Language.fromIsoCode)
        .nonNulls
        .toList();

    if (source != null && languages != null) {
      return FeedSearchFiltersState(source: source, languages: languages);
    }

    return FeedSearchFiltersState.initial();
  }
}
