// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_interests_notifier.r.g.dart';

@riverpod
class SelectedInterestsNotifier extends _$SelectedInterestsNotifier {
  @override
  Set<String> build() {
    return {};
  }

  set interests(Set<String> interests) {
    state = interests;
  }

  void toggleSubcategory({required FeedType feedType, required String subcategoryKey}) {
    final availableInterests = ref.read(feedUserInterestsProvider(feedType)).valueOrNull;
    final category = availableInterests?.parentFor(subcategoryKey);
    if (category == null || availableInterests == null) return;

    final updatedInterests = Set<String>.from(state);
    if (state.contains(subcategoryKey)) {
      updatedInterests.remove(subcategoryKey);
      final subcategoriesKeys = availableInterests.categories[category]?.children.keys ?? {};
      if (subcategoriesKeys.none(updatedInterests.contains)) {
        updatedInterests.remove(category);
      }
    } else {
      final availableCategories = availableInterests.categories.keys.toSet();
      final selectedSubcategories = state.whereNot(availableCategories.contains);
      if (selectedSubcategories.length >= 3) return;
      updatedInterests.addAll([subcategoryKey, category]);
    }

    state = updatedInterests;
  }
}
