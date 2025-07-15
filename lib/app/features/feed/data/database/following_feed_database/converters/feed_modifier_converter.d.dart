// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';

// Feed modifier is a part of the primary key, so it might not be null on db level.
// So we map null values to -1
class FeedModifierConverter extends TypeConverter<FeedModifier?, int> {
  const FeedModifierConverter();

  @override
  FeedModifier? fromSql(int fromDb) {
    return switch (fromDb) {
      -1 => null,
      0 => FeedModifier.top(),
      1 => FeedModifier.trending(),
      2 => FeedModifier.explore(
          ExploreModifierType.unclassified, //TODO[modifiers]: what should we save here?
        ),
      _ => throw UnsupportedError('Unknown FeedModifier value: $fromDb'),
    };
  }

  @override
  int toSql(FeedModifier? value) {
    return switch (value) {
      FeedModifierTop() => 0,
      FeedModifierTrending() => 1,
      FeedModifierExplore() => 2,
      null => -1
    };
  }
}
