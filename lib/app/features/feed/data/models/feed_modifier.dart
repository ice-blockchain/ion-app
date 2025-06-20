// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.c.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';

typedef FeedFilterData = ({List<SearchExtension> search, Map<String, List<String>> tags});

enum FeedModifier {
  top,
  trending,
  explore;

  FeedFilterData filter({required bool excludeUnclassifiedFromExplore}) {
    switch (this) {
      case FeedModifier.top:
        return (search: [TopSearchExtension()], tags: {});
      case FeedModifier.trending:
        return (search: [TrendingSearchExtension()], tags: {});
      case FeedModifier.explore:
        return (
          search: [],
          tags: {
            if (excludeUnclassifiedFromExplore)
              '!#${RelatedHashtag.tagName}': [FeedInterests.unclassified],
          }
        );
    }
  }
}

class FeedFilterFactory {
  FeedFilterFactory({required this.feedConfig});

  final FeedConfig feedConfig;

  FeedFilterData create(FeedModifier modifier) {
    return modifier.filter(
      excludeUnclassifiedFromExplore: feedConfig.excludeUnclassifiedFromExplore,
    );
  }
}
