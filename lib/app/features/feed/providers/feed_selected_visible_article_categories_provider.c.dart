// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_selected_visible_article_categories_provider.c.g.dart';

@riverpod
class FeedSelectedVisibleArticleCategories extends _$FeedSelectedVisibleArticleCategories {
  static const _feedSelectedVisibleArticleCategories = 'feed_selected_visible_article_categories';

  @override
  Set<String> build() {
    _listenChanges();
    _listenAvailableCategories();

    final savedState = _loadSavedState();

    return savedState;
  }

  set categories(Set<String> categories) {
    state = categories;
  }

  void _listenChanges() {
    listenSelf((_, next) => _saveState(next));
  }

  void _listenAvailableCategories() {
    ref.listen(feedUserInterestsProvider(FeedType.article), (_, next) {
      final categories = next.valueOrNull;
      if (categories == null ||
          (state.isNotEmpty && categories.categories.keys.toSet().containsAll(state))) {
        return;
      }
      final availableCategories = categories.categories.keys.toSet();
      state = availableCategories;
    });
  }

  void _saveState(Set<String> state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return;
    }

    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_feedSelectedVisibleArticleCategories, state.toList());
  }

  Set<String> _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return const {};
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final categories = userPreferencesService
        .getValue<List<String>>(_feedSelectedVisibleArticleCategories)
        ?.toSet();

    return categories ?? {};
  }
}
