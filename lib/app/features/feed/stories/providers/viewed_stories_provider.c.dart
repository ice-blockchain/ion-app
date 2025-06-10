// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'viewed_stories_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ViewedStoriesController extends _$ViewedStoriesController {
  static const _key = 'viewedStories';

  @override
  Set<String> build() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final prefs = ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final viewedList = prefs.getValue<List<String>>(_key) ?? [];

    return viewedList.toSet();
  }

  Future<void> markStoryAsViewed(String storyId) async {
    if (!state.contains(storyId)) {
      final updated = {...state, storyId};
      state = updated;

      await _saveToPrefs(updated);
    }
  }

  /// Synchronizes the local viewed stories list with currently available stories.
  /// Removes any story IDs that are no longer present in [validIds], so we don't keep track of
  /// viewed status for stories that have expired.
  Future<void> syncAvailableStories(List<String> validIds) async {
    final validSet = validIds.toSet();
    final newState = state.intersection(validSet);
    if (newState.length != state.length) {
      state = newState;

      await _saveToPrefs(newState);
    }
  }

  Future<void> _saveToPrefs(Set<String> stories) async {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
    final prefs = ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    await prefs.setValue<List<String>>(_key, stories.toList());
  }
}
