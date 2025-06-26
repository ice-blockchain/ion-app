// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_selected_article_categories_provider.r.g.dart';

@riverpod
class FeedSelectedArticleCategories extends _$FeedSelectedArticleCategories {
  static const _feedSelectedArticleCategories = 'feed_selected_article_categories';

  @override
  Set<String> build() {
    _listenChanges();

    final savedState = _loadSavedState();

    final availableCategoriesKeys = ref.watch(
      feedUserInterestsProvider(FeedType.article)
          .select((state) => state.valueOrNull?.categories.keys.toSet() ?? {}),
    );
    if (availableCategoriesKeys.isEmpty) {
      return savedState;
    }

    return savedState.intersection(availableCategoriesKeys);
  }

  set categories(Set<String> categories) {
    state = categories;
  }

  void _listenChanges() {
    listenSelf((_, next) => _saveState(next));
  }

  void _saveState(Set<String> state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return;
    }

    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_feedSelectedArticleCategories, state.toList());
  }

  Set<String> _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (identityKeyName == null) {
      return const {};
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final categories =
        userPreferencesService.getValue<List<String>>(_feedSelectedArticleCategories)?.toSet();

    return categories ?? {};
  }
}
