import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/models/user_fetch_state.dart';
import 'package:ion/app/features/feed/providers/relevant_users_to_fetch_service.r.dart';

class FakeRepository implements UsersFetchStatesRepository {
  FakeRepository(this.states);
  List<UserFetchState> states;

  @override
  Future<void> save(
    String pubkey, {
    required FeedType feedType,
    required bool hasContent,
    FeedModifier? feedModifier,
  }) async {}

  @override
  Future<List<UserFetchState>> select({
    required List<String> pubkeys,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    return states.where((s) => pubkeys.contains(s.pubkey)).toList();
  }
}

void main() {
  group('RelevantUsersToFetchService', () {
    final now = DateTime(2025, 7, 7, 12);
    final user1 = UserFetchState(
      pubkey: 'user1',
      lastFetchTime: now.subtract(const Duration(hours: 2)),
      lastContentTime: now.subtract(const Duration(hours: 2)),
    );
    final user2 = UserFetchState(
      pubkey: 'user2',
      emptyFetchCount: 1,
      lastFetchTime: now.subtract(const Duration(hours: 2)),
      lastContentTime: now.subtract(const Duration(hours: 2)),
    );
    final user3 = UserFetchState(
      pubkey: 'user3',
    );

    test('returns users sorted by score (highest first)', () async {
      final repo = FakeRepository([user1, user2, user3]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['user1', 'user2', 'user3'],
        feedType: FeedType.post,
        limit: 3,
      );
      expect(result.length, 3);
      // user3 has never been fetched, so should have the highest score
      expect(result.first.state.pubkey, 'user3');
      // user1 and user2 are sorted by score
      expect(result.map((e) => e.state.pubkey), containsAll(['user1', 'user2', 'user3']));
    });

    test('respects the limit', () async {
      final repo = FakeRepository([user1, user2, user3]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['user1', 'user2', 'user3'],
        feedType: FeedType.post,
        limit: 2,
      );
      expect(result.length, 2);
    });

    test('filters by pubkeys', () async {
      final repo = FakeRepository([user1, user2, user3]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['user1', 'user2'],
        feedType: FeedType.post,
        limit: 5,
      );
      expect(result.length, 2);
      expect(result.map((e) => e.state.pubkey), containsAll(['user1', 'user2']));
    });

    test('user with higher emptyFetchCount has lower score', () async {
      final userWithNoRetries = UserFetchState(
        pubkey: 'userA',
        emptyFetchCount: 3,
        lastFetchTime: now.subtract(const Duration(hours: 5)),
        lastContentTime: now.subtract(const Duration(hours: 6)),
      );
      final userWithRetries = UserFetchState(
        pubkey: 'userB',
        emptyFetchCount: 2,
        lastFetchTime: now.subtract(const Duration(hours: 5)),
        lastContentTime: now.subtract(const Duration(hours: 6)),
      );
      final repo = FakeRepository([userWithNoRetries, userWithRetries]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['userA', 'userB'],
        feedType: FeedType.post,
        limit: 2,
      );
      expect(result.first.state.pubkey, 'userB');
      expect(result.last.state.pubkey, 'userA');
    });

    test('user with more recent lastFetchTime has higher score', () async {
      final userOlderFetch = UserFetchState(
        pubkey: 'userC',
        lastFetchTime: now.subtract(const Duration(hours: 10)),
        lastContentTime: now.subtract(const Duration(hours: 10)),
      );
      final userRecentFetch = UserFetchState(
        pubkey: 'userD',
        lastFetchTime: now.subtract(const Duration(hours: 1)),
        lastContentTime: now.subtract(const Duration(hours: 10)),
      );
      final repo = FakeRepository([userOlderFetch, userRecentFetch]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['userC', 'userD'],
        feedType: FeedType.post,
        limit: 2,
      );
      expect(result.first.state.pubkey, 'userC');
      expect(result.last.state.pubkey, 'userD');
    });

    test('user with more recent lastContentTime has higher score', () async {
      final userBest = UserFetchState(
        pubkey: 'userE',
        lastFetchTime: now.subtract(const Duration(hours: 10)),
        lastContentTime: now.subtract(const Duration(hours: 2)),
      );
      final userWorst = UserFetchState(
        pubkey: 'userF',
        lastFetchTime: now.subtract(const Duration(hours: 10)),
        lastContentTime: now.subtract(const Duration(hours: 10)),
      );
      final repo = FakeRepository([userBest, userWorst]);
      final service = RelevantUsersToFetchService(repository: repo);
      final result = await service.getRelevantUsersToFetch(
        ['userE', 'userF'],
        feedType: FeedType.post,
        limit: 2,
      );
      expect(result.first.state.pubkey, 'userE');
      expect(result.last.state.pubkey, 'userF');
    });
  });
}
