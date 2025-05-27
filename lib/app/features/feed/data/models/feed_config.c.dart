// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_config.c.freezed.dart';
part 'feed_config.c.g.dart';

@freezed
class FeedConfig with _$FeedConfig {
  const factory FeedConfig({
    /// A category is considered "interesting" to the user if its weight
    /// is bigger than this threshold multiplied by the total weight of all sibling
    /// categories under the same parent.
    required double interestedThreshold,

    /// The chance of rolling a category that the user is not interested in.
    required double notInterestedCategoryChance,

    /// The chance of rolling a subcategory that the user is not interested in.
    required double notInterestedSubcategoryChance,
    @DurationMillisecondsConverter() required Duration followingMaxAge,
    @DurationMillisecondsConverter() required Duration topMaxAge,
    @DurationMillisecondsConverter() required Duration trendingMaxAge,
    @DurationMillisecondsConverter() required Duration exploreMaxAge,
  }) = _FeedConfig;
  const FeedConfig._();

  factory FeedConfig.fromJson(Map<String, dynamic> json) => _$FeedConfigFromJson(json);
}

class DurationMillisecondsConverter implements JsonConverter<Duration, int> {
  const DurationMillisecondsConverter();

  @override
  Duration fromJson(int milliseconds) => Duration(milliseconds: milliseconds);

  @override
  int toJson(Duration duration) => duration.inMilliseconds;
}
