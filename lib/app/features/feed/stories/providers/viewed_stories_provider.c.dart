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
    final list = localStorage.getStringList(_key) ?? [];

    return list.toSet();
  }

  Future<void> markStoryAsViewed(String storyId) async {
    if (!state.contains(storyId)) {
      state = {...state}..add(storyId);
      final localStorage = ref.read(localStorageProvider);
      await localStorage.setStringList(_key, state.toList());
    }
  }

  Future<void> clearViewedStories() async {
    state = {};
    final localStorage = ref.read(localStorageProvider);
    await localStorage.remove(_key);
  }
}
