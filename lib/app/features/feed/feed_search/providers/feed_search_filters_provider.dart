import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/core/model/language.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_filter_people.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filters_provider.freezed.dart';
part 'feed_search_filters_provider.g.dart';

@Freezed(copyWith: true, equal: true)
class FeedSearchFiltersState with _$FeedSearchFiltersState {
  const factory FeedSearchFiltersState({
    required List<Language> languages,
    required FeedSearchFilterPeople people,
  }) = _FeedSearchFiltersState;

  factory FeedSearchFiltersState.initial() {
    return const FeedSearchFiltersState(
      people: FeedSearchFilterPeople.anyone,
      languages: [Language.english],
    );
  }
}

@riverpod
class FeedSearchFilter extends _$FeedSearchFilter {
  static const _feedSearchPeopleFilterKey = 'FeedSearchFilter:people';
  static const _feedSearchLanguagesFilterKey = 'FeedSearchFilter:languages';

  @override
  FeedSearchFiltersState build() {
    _listenChanges();

    final savedState = _loadSavedState();

    return savedState;
  }

  set filterPeople(FeedSearchFilterPeople filter) {
    state = state.copyWith(people: filter);
  }

  set languages(List<Language> languages) {
    state = state.copyWith(languages: languages);
  }

  set newState(FeedSearchFiltersState newState) {
    state = newState;
  }

  void _listenChanges() {
    ref.listenSelf((_, next) => _saveState(next));
  }

  void _saveState(FeedSearchFiltersState state) {
    final userId = ref.read(currentUserIdSelectorProvider);
    ref.read(userPreferencesServiceProvider(userId: userId))
      ..setEnum(_feedSearchPeopleFilterKey, state.people)
      ..setValue<List<String>>(
        _feedSearchLanguagesFilterKey,
        state.languages.map((lang) => lang.isoCode).toList(),
      );
  }

  FeedSearchFiltersState _loadSavedState() {
    final userId = ref.watch(currentUserIdSelectorProvider);
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

    final people =
        userPreferencesService.getEnum(_feedSearchPeopleFilterKey, FeedSearchFilterPeople.values);
    final languages = userPreferencesService
        .getValue<List<String>>(_feedSearchLanguagesFilterKey)
        ?.map((isoCode) => Language.values.firstWhere((language) => language.isoCode == isoCode))
        .toList();

    if (people != null && languages != null) {
      return FeedSearchFiltersState(people: people, languages: languages);
    }

    return FeedSearchFiltersState.initial();
  }
}
