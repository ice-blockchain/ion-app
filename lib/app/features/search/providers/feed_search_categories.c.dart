// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_categories.c.g.dart';

@riverpod
List<AdvancedSearchCategory> searchCategories(Ref ref) {
  final filterCategories = ref.watch(feedSearchFilterProvider.select((state) => state.categories));
  return AdvancedSearchCategory.values
      .where(
        (category) =>
            category.isFeed &&
            // exclude videos category if videos are not checked in the filter
            (filterCategories[FeedCategory.videos].falseOrValue ||
                category != AdvancedSearchCategory.videos),
      )
      .toList();
}
