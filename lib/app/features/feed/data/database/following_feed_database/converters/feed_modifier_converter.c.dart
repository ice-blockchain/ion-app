// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';

class FeedModifierConverter extends TypeConverter<FeedModifier, int> {
  const FeedModifierConverter();

  @override
  FeedModifier fromSql(int fromDb) {
    return switch (fromDb) {
      0 => FeedModifier.top,
      1 => FeedModifier.trending,
      2 => FeedModifier.explore,
      _ => throw UnsupportedError('Unknown FeedModifier value: $fromDb'),
    };
  }

  @override
  int toSql(FeedModifier value) {
    return switch (value) {
      FeedModifier.top => 0,
      FeedModifier.trending => 1,
      FeedModifier.explore => 2,
    };
  }
}
