// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/feed_interests.f.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';

typedef FeedFilterData = ({List<SearchExtension> search, Map<String, List<String>> tags});

sealed class FeedModifier {
  const FeedModifier({required this.name});

  factory FeedModifier.top() = FeedModifierTop;
  factory FeedModifier.trending() = FeedModifierTrending;
  factory FeedModifier.explore(ExploreModifierType type) = FeedModifierExplore;

  final String name;

  FeedFilterData filter({String? interest});
}

class FeedModifierTop extends FeedModifier {
  const FeedModifierTop() : super(name: 'top');

  @override
  FeedFilterData filter({String? interest}) {
    return (
      search: [TopSearchExtension()],
      tags: {
        if (interest != null) '#${RelatedHashtag.tagName}': [interest],
      }
    );
  }
}

class FeedModifierTrending extends FeedModifier {
  const FeedModifierTrending() : super(name: 'trending');

  @override
  FeedFilterData filter({String? interest}) {
    return (
      search: [TrendingSearchExtension()],
      tags: {
        if (interest != null) '#${RelatedHashtag.tagName}': [interest],
      }
    );
  }
}

class FeedModifierExplore extends FeedModifier {
  FeedModifierExplore(this.type) : super(name: 'explore-${type.name}');

  final ExploreModifierType type;

  @override
  FeedFilterData filter({String? interest}) {
    return (
      search: [],
      tags: switch (type) {
        ExploreModifierType.unclassified => {
            '!#${RelatedHashtag.tagName}': [FeedInterests.unclassified],
          },
        ExploreModifierType.interests => {
            if (interest != null) '#${RelatedHashtag.tagName}': [interest],
          },
        ExploreModifierType.plain => {},
      }
    );
  }
}

enum ExploreModifierType { unclassified, interests, plain }
