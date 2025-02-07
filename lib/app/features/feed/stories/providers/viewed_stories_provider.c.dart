// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'viewed_stories_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ViewedStoriesController extends _$ViewedStoriesController {
  static const _key = 'StoriesState:viewedStories';

  @override
  Set<String> build() {
    final localStorage = ref.watch(localStorageProvider);
    final viewedList = localStorage.getStringList(_key) ?? [];

    return viewedList.toSet();
  }

  Future<void> markStoryAsViewed(String storyId) async {
    if (!state.contains(storyId)) {
      final updated = {...state, storyId};
      state = updated;

      await _saveToPrefs(updated);
    }
  }

  Future<void> filterBy(List<String> validIds) async {
    final validSet = validIds.toSet();
    final newState = state.intersection(validSet);
    if (newState.length != state.length) {
      state = newState;

      await _saveToPrefs(newState);
    }
  }

  Future<void> _saveToPrefs(Set<String> stories) async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setStringList(_key, stories.toList());
  }
}
