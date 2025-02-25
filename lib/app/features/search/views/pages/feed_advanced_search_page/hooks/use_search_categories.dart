import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
                (filterCategories.categories.contains(FeedCategory.videos) ||
                    category != AdvancedSearchCategory.videos),
          )
          .toList();
    },
    [filterCategories],
  );
}
