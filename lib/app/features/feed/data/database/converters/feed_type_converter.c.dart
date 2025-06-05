// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';

class FeedTypeConverter extends TypeConverter<FeedType, int> {
  const FeedTypeConverter();

  @override
  FeedType fromSql(int fromDb) {
    return switch (fromDb) {
      0 => FeedType.post,
      1 => FeedType.story,
      2 => FeedType.video,
      3 => FeedType.article,
      _ => throw UnsupportedError('Unknown FeedType value: $fromDb'),
    };
  }

  @override
  int toSql(FeedType value) {
    return switch (value) {
      FeedType.post => 0,
      FeedType.story => 1,
      FeedType.video => 2,
      FeedType.article => 3,
    };
  }
}
