// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/intents/toggle_repost_intent.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/repost_sync_strategy.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

void main() {
  group('ToggleRepostIntent.optimistic()', () {
    const ref = ImmutableEventReference(
      masterPubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );
    const intent = ToggleRepostIntent();

    test('adds repost if it was not reposted', () {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 3,
        quotesCount: 2,
        repostedByMe: false,
      );
      final next = intent.optimistic(prev);

      expect(next.repostedByMe, isTrue);
      expect(next.repostsCount, 4);
      expect(next.quotesCount, 2);
      expect(next.totalRepostsCount, 6);
    });

    test('removes repost if it was reposted', () {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 4,
        quotesCount: 2,
        repostedByMe: true,
        myRepostReference: ReplaceableEventReference(
          kind: 16,
          masterPubkey: 'testPubkey',
          dTag: 'testTag',
        ),
      );
      final next = intent.optimistic(prev);

      expect(next.repostedByMe, isFalse);
      expect(next.repostsCount, 3);
      expect(next.quotesCount, 2);
      expect(next.totalRepostsCount, 5);
      expect(next.myRepostReference, isNull);
    });

    test('handles zero reposts count correctly', () {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 0,
        quotesCount: 2,
        repostedByMe: true,
        myRepostReference: ReplaceableEventReference(
          kind: 16,
          masterPubkey: 'testPubkey',
          dTag: 'testTag',
        ),
      );
      final next = intent.optimistic(prev);

      expect(next.repostedByMe, isFalse);
      expect(next.repostsCount, 0);
      expect(next.quotesCount, 2);
      expect(next.totalRepostsCount, 2);
      expect(next.myRepostReference, isNull);
    });
  });

  group('RepostSyncStrategy.send()', () {
    late bool repostSent;
    late bool deletionSent;
    late EventReference? deletedRepostRef;
    late EventReference? createdRepostRef;
    late List<EventReference> invalidatedCacheRefs;

    RepostSyncStrategy strategy0() {
      return RepostSyncStrategy(
        createRepost: (EventReference _) async {
          repostSent = true;
          createdRepostRef = const ReplaceableEventReference(
            kind: 16,
            masterPubkey: 'testPubkey',
            dTag: 'testTag',
          );
          return createdRepostRef!;
        },
        deleteRepost: (EventReference ref) async {
          deletionSent = true;
          deletedRepostRef = ref;
        },
        invalidateCounterCache: (ref) {
          invalidatedCacheRefs.add(ref);
        },
      );
    }

    setUp(() {
      repostSent = false;
      deletionSent = false;
      deletedRepostRef = null;
      invalidatedCacheRefs = [];
    });

    const ref = ImmutableEventReference(
      masterPubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );

    test('calls createRepost when toggling to repost', () async {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 0,
        quotesCount: 0,
        repostedByMe: false,
      );
      final opt = prev.copyWith(repostedByMe: true, repostsCount: 1);

      final result = await strategy0().send(prev, opt);

      expect(result.eventReference, ref);
      expect(result.repostsCount, 1);
      expect(result.quotesCount, 0);
      expect(result.repostedByMe, true);
      expect(result.myRepostReference, createdRepostRef);
      expect(repostSent, isTrue);
      expect(deletionSent, isFalse);
      expect(invalidatedCacheRefs, isEmpty);
    });

    test('calls deleteRepost when unreposting', () async {
      const repostRef = ImmutableEventReference(
        masterPubkey: 'pubkey',
        eventId: 'abc',
        kind: GenericRepostEntity.kind,
      );

      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
        myRepostReference: repostRef,
      );
      final opt = prev.copyWith(repostedByMe: false, repostsCount: 0);

      final strategy = strategy0();
      final result = await strategy.send(prev, opt);

      expect(result.eventReference, ref);
      expect(result.repostsCount, 0);
      expect(result.quotesCount, 0);
      expect(result.repostedByMe, false);
      expect(result.myRepostReference, opt.myRepostReference);
      expect(repostSent, isFalse);
      expect(deletionSent, isTrue);
      expect(deletedRepostRef, repostRef);
      expect(invalidatedCacheRefs, isEmpty);
    });

    test('handles null myRepostReference gracefully', () async {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
      );
      final opt = prev.copyWith(repostedByMe: false, repostsCount: 0);

      final strategy = strategy0();
      final result = await strategy.send(prev, opt);

      expect(result.eventReference, ref);
      expect(result.repostsCount, 0);
      expect(result.quotesCount, 0);
      expect(result.repostedByMe, false);
      expect(result.myRepostReference, isNull);
      expect(repostSent, isFalse);
      expect(deletionSent, isFalse);
      expect(invalidatedCacheRefs, isEmpty);
    });

    test('returns unchanged state when no toggle occurs', () async {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
      );
      const opt = prev;

      final strategy = strategy0();
      final result = await strategy.send(prev, opt);

      expect(result.eventReference, ref);
      expect(result.repostsCount, 1);
      expect(result.quotesCount, 0);
      expect(result.repostedByMe, true);
      expect(result.myRepostReference, isNull);
      expect(repostSent, isFalse);
      expect(deletionSent, isFalse);
      expect(invalidatedCacheRefs, isEmpty);
    });

    test('handles createRepost failure gracefully', () async {
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 0,
        quotesCount: 0,
        repostedByMe: false,
      );
      final opt = prev.copyWith(repostedByMe: true, repostsCount: 1);

      final failingStrategy = RepostSyncStrategy(
        createRepost: (_) async {
          throw Exception('Network error');
        },
        deleteRepost: (_) async {},
        invalidateCounterCache: (_) {},
      );

      expect(
        () => failingStrategy.send(prev, opt),
        throwsException,
      );
    });

    test('handles deleteRepost failure gracefully', () async {
      const repostRef = ImmutableEventReference(
        masterPubkey: 'mypubkey',
        eventId: 'repost123',
        kind: 6,
      );
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
        myRepostReference: repostRef,
      );
      final opt = prev.copyWith(repostedByMe: false, repostsCount: 0);

      final failingStrategy = RepostSyncStrategy(
        createRepost: (_) async => repostRef,
        deleteRepost: (_) async {
          throw Exception('Network error');
        },
        invalidateCounterCache: (_) {},
      );

      expect(
        () => failingStrategy.send(prev, opt),
        throwsException,
      );
    });

    test('does not invalidate cache after deletion', () async {
      const repostRef = ImmutableEventReference(
        masterPubkey: 'mypubkey',
        eventId: 'repost123',
        kind: 6,
      );
      const prev = PostRepost(
        eventReference: ref,
        repostsCount: 1,
        quotesCount: 0,
        repostedByMe: true,
        myRepostReference: repostRef,
      );
      final opt = prev.copyWith(repostedByMe: false, repostsCount: 0);

      var deletionCallCount = 0;
      final strategy = RepostSyncStrategy(
        createRepost: (_) async => repostRef,
        deleteRepost: (_) async {
          deletionCallCount++;
        },
        invalidateCounterCache: (ref) {
          invalidatedCacheRefs.add(ref);
        },
      );

      await strategy.send(prev, opt);

      expect(invalidatedCacheRefs, isEmpty);
      expect(deletionCallCount, 1);
    });
  });
}
