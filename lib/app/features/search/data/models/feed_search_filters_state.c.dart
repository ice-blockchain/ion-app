// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';

part 'feed_search_filters_state.c.freezed.dart';
part 'feed_search_filters_state.c.g.dart';

@freezed
class FeedSearchFiltersState with _$FeedSearchFiltersState {
  const factory FeedSearchFiltersState({
    required Map<FeedCategory, bool> categories,
    required FeedSearchSource source,
  }) = _FeedSearchFiltersState;

  factory FeedSearchFiltersState.initial() {
    return const FeedSearchFiltersState(
      source: FeedSearchSource.anyone,
      categories: {FeedCategory.feed: true, FeedCategory.videos: true, FeedCategory.articles: true},
    );
  }

  factory FeedSearchFiltersState.fromJson(Map<String, dynamic> json) =>
      _$FeedSearchFiltersStateFromJson(json);
}
