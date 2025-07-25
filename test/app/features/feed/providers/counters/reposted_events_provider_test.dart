// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/providers/counters/reposted_events_provider.r.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/post_repost_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../test_utils.dart';
import '../../reposts/mocks/repost_mocks.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('isRepostedProvider', () {
    const eventRef = ImmutableEventReference(
      masterPubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );

    const myRepostRef = ReplaceableEventReference(
      kind: 16,
      masterPubkey: 'testPubkey',
      dTag: 'testTag',
    );

    test('returns true when optimistic state shows repostedByMe true', () {
      // Test that when optimistic state has repostedByMe = true, isReposted returns true
      const optimisticPostRepost = PostRepost(
        eventReference: eventRef,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
        myRepostReference: myRepostRef,
      );

      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          // Override findRepostInCacheProvider to return optimistic state
          findRepostInCacheProvider(eventRef).overrideWith((ref) => optimisticPostRepost),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      expect(result, true);
    });

    test('returns false when optimistic state shows repostedByMe false', () {
      // Test that when optimistic state has repostedByMe = false, isReposted returns false
      const optimisticPostRepost = PostRepost(
        eventReference: eventRef,
        repostsCount: 0,
        quotesCount: 0,
        repostedByMe: false,
      );

      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          // Override findRepostInCacheProvider to return optimistic state
          findRepostInCacheProvider(eventRef).overrideWith((ref) => optimisticPostRepost),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      expect(result, false);
    });

    test('returns cached repostedByMe value when no optimistic state', () {
      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          findRepostInCacheProvider(eventRef).overrideWith((ref) {
            return const PostRepost(
              eventReference: eventRef,
              repostsCount: 1,
              quotesCount: 0,
              repostedByMe: true,
              myRepostReference: myRepostRef,
            );
          }),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      expect(result, true);
    });

    test('returns false when cached PostRepost has repostedByMe false', () {
      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          findRepostInCacheProvider(eventRef).overrideWith((ref) {
            // This can happen after rollback - cached object exists but repostedByMe is false
            return const PostRepost(
              eventReference: eventRef,
              repostsCount: 0,
              quotesCount: 0,
              repostedByMe: false,
            );
          }),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      expect(result, false);
    });

    test('returns false when no optimistic state and no cache', () {
      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          findRepostInCacheProvider(eventRef).overrideWith((ref) {
            return null;
          }),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      expect(result, false);
    });

    test('crucial test - checks repostedByMe field not just null', () {
      // This test verifies the fix we made to isRepostedProvider
      // Before: it was checking cached != null
      // After: it checks cached?.repostedByMe ?? false
      
      final container = createContainer(
        overrides: [
          currentPubkeySelectorProvider.overrideWith(() => FakeCurrentPubkeySelector('testPubkey')),
          findRepostInCacheProvider(eventRef).overrideWith((ref) {
            // Return a PostRepost object that exists but has repostedByMe = false
            // This simulates the case after rollback when optimistic state was reverted
            return const PostRepost(
              eventReference: eventRef,
              repostsCount: 10, // High count from cache
              quotesCount: 0,
              repostedByMe: false, // But not reposted by current user
            );
          }),
        ],
      );

      final result = container.read(isRepostedProvider(eventRef));
      
      // This is the key assertion - even though cached object exists,
      // isReposted should return false because repostedByMe is false
      expect(result, false);
    });
  });

  group('PostRepost totalRepostsCount', () {
    const eventRef = ImmutableEventReference(
      masterPubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );

    const myRepostRef = ReplaceableEventReference(
      kind: 16,
      masterPubkey: 'testPubkey',
      dTag: 'testTag',
    );

    test('ensures minimum count of 1 when repostedByMe is true', () {
      const postRepost = PostRepost(
        eventReference: eventRef,
        repostsCount: 0,
        quotesCount: 0,
        repostedByMe: true,
        myRepostReference: myRepostRef,
      );

      // This test verifies our fix for the visual inconsistency
      expect(postRepost.totalRepostsCount, 1);
      expect(postRepost.repostedByMe, true);
    });

    test('returns 0 when repostedByMe is false', () {
      const postRepost = PostRepost(
        eventReference: eventRef,
        repostsCount: 0,
        quotesCount: 0,
        repostedByMe: false,
      );

      expect(postRepost.totalRepostsCount, 0);
      expect(postRepost.repostedByMe, false);
    });

    test('returns actual sum when count > 0', () {
      const postRepost = PostRepost(
        eventReference: eventRef,
        repostsCount: 5,
        quotesCount: 3,
        repostedByMe: true,
        myRepostReference: myRepostRef,
      );

      expect(postRepost.totalRepostsCount, 8);
    });
  });
}
