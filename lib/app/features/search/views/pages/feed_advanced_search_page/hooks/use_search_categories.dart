// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';

List<AdvancedSearchCategory> useSearchCategories(WidgetRef ref) {
  final filterCategories = ref.watch(feedSearchFilterProvider);
  return useMemoized(
    () {
      return AdvancedSearchCategory.values
          .where(
            (category) =>
                category.isFeed &&
                // exclude videos category if videos are not checked in the filter
                (filterCategories.categories[FeedCategory.videos].falseOrValue ||
                    category != AdvancedSearchCategory.videos),
          )
          .toList();
    },
    [filterCategories],
  );
}
