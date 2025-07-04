// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/models/user_fetch_state.dart';
import 'package:ion/app/features/feed/data/repository/following_users_fetch_states_repository.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relevant_users_to_fetch_service.r.g.dart';

class RelevantUsersToFetchService {
  RelevantUsersToFetchService({required UsersFetchStatesRepository repository})
      : _repository = repository;

  final UsersFetchStatesRepository _repository;

  Future<List<String>> getRelevantUsersToFetch(
    List<String> pubkeys, {
    required FeedType feedType,
    required int limit,
    FeedModifier? feedModifier,
  }) async {
    final now = DateTime.now();

    final userStates =
        await _repository.select(pubkeys: pubkeys, feedType: feedType, feedModifier: feedModifier);

    final scored = userStates.map((userState) {
      final score = _calculateUserScore(userState, now: now);
      return (state: userState, score: score);
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scored.take(limit).map((item) => item.state.pubkey).toList();
  }

  double _calculateUserScore(UserFetchState state, {DateTime? now}) {
    now ??= DateTime.now();

    final lastFetch = state.lastFetchTime;
    final lastContent = state.lastContentTime ?? DateTime.fromMillisecondsSinceEpoch(0);

    // If never fetched, return the highest score
    if (lastFetch == null) return 1;

    final contentAgeSeconds = now.difference(lastContent).inSeconds;
    final timeSinceLastFetchSeconds = now.difference(lastFetch).inSeconds;

    // Content recency factor: scales from 0.5 (old content) to 1 (fresh content)
    // 5 seconds  ≈ 0.9993
    // 1 minute   ≈ 0.9918
    // 1 hour     ≈ 0.75
    // 1 day      ≈ 0.5
    final contentRecencyFactor = 0.5 + 0.5 / (1 + contentAgeSeconds / 3600); // scale by hours

    // Exponential backoff factor
    // 0 = 1
    // 1 = 0.5
    // 2 = 0.25
    // 3 = 0.125
    // 4 = 0.0625
    final backoffFactor = 1 / pow(2, state.emptyFetchCount);

    // Fetch recency factor: scales from 0 (just fetched) to 1 as time passes
    // 5 seconds ≈ 0.00139
    // 1 minute  ≈ 0.01653
    // 10 minutes   ≈ 0.15485
    // 1 hour ≈ 0.63212
    // 1 day ≈ 0.99998
    final fetchRecencyFactor = 1 - exp(-(1 / 3600) * timeSinceLastFetchSeconds);

    // Final score
    return contentRecencyFactor * fetchRecencyFactor * backoffFactor;
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
  final repository = ref.watch(followingUsersFetchStatesRepositoryProvider);
  return RelevantUsersToFetchService(repository: repository);
}
