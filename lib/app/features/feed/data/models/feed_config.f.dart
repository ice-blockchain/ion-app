// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_config.f.freezed.dart';
part 'feed_config.f.g.dart';

@freezed
class FeedConfig with _$FeedConfig {
  const factory FeedConfig({
    required double interestedThreshold,
    required double notInterestedCategoryChance,
    required int concurrentRequests,
    required int concurrentMediaDownloadsLimit,
    @DurationMillisecondsConverter() required Duration followingReqMaxAge,
    @DurationMillisecondsConverter() required Duration followingCacheMaxAge,
    @DurationMillisecondsConverter() required Duration topMaxAge,
    @DurationMillisecondsConverter() required Duration trendingMaxAge,
    @DurationMillisecondsConverter() required Duration exploreMaxAge,
    @DurationMillisecondsConverter() required Duration repostThrottleDelay,
    required bool excludeUnclassifiedFromExplore,
    required double forYouMaxRetriesMultiplier,
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
