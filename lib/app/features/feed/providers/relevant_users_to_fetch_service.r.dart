// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/models/user_fetch_state.dart';
import 'package:ion/app/features/feed/data/repository/following_feed_seen_events_repository.r.dart';
import 'package:ion/app/features/feed/data/repository/following_users_fetch_states_repository.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relevant_users_to_fetch_service.r.g.dart';

class RelevantUsersToFetchService {
  RelevantUsersToFetchService({
    required UsersFetchStatesRepository fetchStatesRepository,
    required FollowingFeedSeenEventsRepository seenEventsRepository,
  })  : _fetchStatesRepository = fetchStatesRepository,
        _seenEventsRepository = seenEventsRepository;

  final UsersFetchStatesRepository _fetchStatesRepository;
  final FollowingFeedSeenEventsRepository _seenEventsRepository;

  Future<List<({double score, UserFetchState state})>> getRelevantUsersToFetch(
    List<String> pubkeys, {
    required FeedType feedType,
    required int limit,
    FeedModifier? feedModifier,
  }) async {
    final now = DateTime.now();

    final usersCreatedContentTime =
        await _seenEventsRepository.getUsersCreatedContentTime(maxUserEvents: 10);

    final userFetchStates = await _fetchStatesRepository.select(
      pubkeys: pubkeys,
      feedType: feedType,
      feedModifier: feedModifier,
    );

    final scored = userFetchStates.map((userFetchState) {
      final score = _calculateUserScore(
        userFetchState,
        contentTime: usersCreatedContentTime[userFetchState.pubkey],
        now: now,
      );
      return (state: userFetchState, score: score);
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored.take(limit).toList();
  }

  double _calculateUserScore(
    UserFetchState state, {
    List<int>? contentTime,
    DateTime? now,
  }) {
    now ??= DateTime.now();

    final lastFetch = state.lastFetchTime;

    // If never fetched, return the highest score
    if (lastFetch == null) return 1;

    final contentFrequencyFactor = _calculateContentFrequencyFactor(contentTime: contentTime);

    final backoffFactor = _calculateBackoffFactor(emptyFetchCount: state.emptyFetchCount);

    final fetchRecencyFactor = _calculateFetchRecencyFactor(lastFetch: lastFetch, now: now);

    // Final score
    return contentFrequencyFactor * fetchRecencyFactor * backoffFactor;
  }

  /// Content frequency factor: scales from 0.5 (no content) to 1 (frequent content)
  ///
  /// So depending on the average gap between last events,
  /// the factor will be:
  /// 1 minute gap    ≈ 0.994
  /// 30 minutes gap  ≈ 0.853
  /// 1 hour gap      ≈ 0.75
  /// 2 hours gap     ≈ 0.625
  /// 1 day gap       ≈ 0.5
  double _calculateContentFrequencyFactor({List<int>? contentTime}) {
    const minScore = 0.5;

    if (contentTime == null || contentTime.length < 2) return minScore;

    final times = contentTime.map((time) => time.toDateTime).toList();

    // Calculate time gaps between consecutive events in seconds
    final gaps = <int>[];
    for (var i = 1; i < times.length; i++) {
      gaps.add(times[i - 1].difference(times[i]).inSeconds);
    }

    // Use exponential decay on gaps to score frequency:
    // smaller gaps => higher weight
    // Half-life = 1 hour gap (3600s): gap of 0s = 1.0, gap of 1h = 0.5, 2h = 0.25, etc.
    final decayRate = log(2) / 3600;

    final gapsScoresSum = gaps.map((gap) => exp(-decayRate * gap)).reduce((a, b) => a + b);

    final averageGapScore = min(gapsScoresSum / gaps.length, 1);

    return minScore + (1 - minScore) * averageGapScore;
  }

  /// Fetch recency factor: scales from 0 (just fetched) to 1 as time passes
  ///
  /// So depending on the time since last fetch,
  /// the factor will be:
  /// 1 minute    ≈ 0.01653
  /// 10 minutes  ≈ 0.15485
  /// 1 hour      ≈ 0.63212
  /// 1 day       ≈ 0.99998
  double _calculateFetchRecencyFactor({
    required DateTime now,
    required DateTime lastFetch,
  }) {
    final timeSinceLastFetchSeconds = now.difference(lastFetch).inSeconds;
    return 1 - exp(-(1 / 3600) * timeSinceLastFetchSeconds);
  }

  /// Backoff factor
  ///
  /// So depending on subsequent number of empty fetches,
  /// the factor will be:
  /// 0 = 1
  /// 1 = 0.5
  /// 2 = 0.25
  /// 3 = 0.125
  /// 4 = 0.0625
  double _calculateBackoffFactor({required int emptyFetchCount}) {
    return 1 / pow(2, emptyFetchCount);
  }
}

abstract class UsersFetchStatesRepository {
  Future<void> save(
    String pubkey, {
    required FeedType feedType,
    required bool hasContent,
    FeedModifier? feedModifier,
  });

  Future<List<UserFetchState>> select({
    required List<String> pubkeys,
    required FeedType feedType,
    FeedModifier? feedModifier,
  });
}

@Riverpod(keepAlive: true)
RelevantUsersToFetchService relevantFollowingUsersToFetchService(Ref ref) {
  final fetchStatesRepository = ref.watch(followingUsersFetchStatesRepositoryProvider);
  final seenEventsRepository = ref.watch(followingFeedSeenEventsRepositoryProvider);
  return RelevantUsersToFetchService(
    fetchStatesRepository: fetchStatesRepository,
    seenEventsRepository: seenEventsRepository,
  );
}
