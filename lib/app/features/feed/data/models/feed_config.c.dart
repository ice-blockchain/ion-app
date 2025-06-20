// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_config.c.freezed.dart';
part 'feed_config.c.g.dart';

@freezed
class FeedConfig with _$FeedConfig {
  const factory FeedConfig({
    required double interestedThreshold,
    required double notInterestedCategoryChance,
    required double notInterestedSubcategoryChance,
    required int concurrentRequests,
    required int concurrentMediaDownloadsLimit,
    @DurationMillisecondsConverter() required Duration followingReqMaxAge,
    @DurationMillisecondsConverter() required Duration followingCacheMaxAge,
    @DurationMillisecondsConverter() required Duration topMaxAge,
    @DurationMillisecondsConverter() required Duration trendingMaxAge,
    @DurationMillisecondsConverter() required Duration exploreMaxAge,
    @DurationMillisecondsConverter() required Duration repostThrottleDelay,
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
