// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/data/models/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/data/models/search_extension.dart';

enum FeedModifier {
  top,
  trending,
  explore;

  ({List<SearchExtension> search, Map<String, List<String>> tags}) get filter {
    switch (this) {
      case FeedModifier.top:
        return (search: [TopSearchExtension()], tags: {});
      case FeedModifier.trending:
        return (search: [TrendingSearchExtension()], tags: {});
      case FeedModifier.explore:
        return (
          search: [],
          tags: {
            '!#${RelatedHashtag.tagName}': ['unclassified'],
          }
        );
    }
  }
}
