// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';

part 'feed_filters_state.c.freezed.dart';

@freezed
class FeedFiltersState with _$FeedFiltersState {
  const factory FeedFiltersState({
    required FeedCategory category,
    required FeedFilter filter,
  }) = _FeedFiltersState;
  const FeedFiltersState._();

  static const FeedCategory defaultCategory = FeedCategory.feed;
  static const FeedFilter defaultFilter = FeedFilter.forYou;
}
