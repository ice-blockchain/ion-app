// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/repost_sync_strategy.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateRepostFunction extends Mock {
  Future<EventReference> call(EventReference ref);
}

class MockDeleteRepostFunction extends Mock {
  Future<void> call(EventReference ref);
}

class MockInvalidateCacheFunction extends Mock {
  void call(EventReference ref);
}

void main() {
  group('RepostSyncStrategy', () {
    late MockCreateRepostFunction mockCreateRepost;
    late MockDeleteRepostFunction mockDeleteRepost;
    late MockInvalidateCacheFunction mockInvalidateCache;
    late RepostSyncStrategy strategy;

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

    setUp(() {
      mockCreateRepost = MockCreateRepostFunction();
      mockDeleteRepost = MockDeleteRepostFunction();
      mockInvalidateCache = MockInvalidateCacheFunction();

      strategy = RepostSyncStrategy(
        createRepost: mockCreateRepost.call,
        deleteRepost: mockDeleteRepost.call,
        invalidateCounterCache: mockInvalidateCache.call,
      );

      // Register fallback values for mocktail
      registerFallbackValue(eventRef);
    });

    group('delete repost scenarios', () {
      test('handles EntityNotFoundException as successful deletion with zero count', () async {
        // Previous state: reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 1,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        // Optimistic state: not reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Mock delete to throw EntityNotFoundException
        when(() => mockDeleteRepost.call(myRepostRef)).thenThrow(EntityNotFoundException('test'));

        // Execute
        final result = await strategy.send(previous, optimistic);

        // Verify result
        expect(result.repostedByMe, isFalse);
        expect(result.myRepostReference, isNull);
        expect(result.repostsCount, 0);

        // Verify cache was invalidated twice (once normally, once for count=0)
        verify(() => mockInvalidateCache.call(eventRef)).called(2);
      });

      test('handles EntityNotFoundException with non-zero count', () async {
        // Previous state: reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 5,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        // Optimistic state: not reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 4,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Mock delete to throw EntityNotFoundException
        when(() => mockDeleteRepost.call(myRepostRef)).thenThrow(EntityNotFoundException('test'));

        // Execute
        final result = await strategy.send(previous, optimistic);

        // Verify result
        expect(result.repostedByMe, isFalse);
        expect(result.myRepostReference, isNull);
        expect(result.repostsCount, 4);

        // Verify cache was invalidated only once (count > 0)
        verify(() => mockInvalidateCache.call(eventRef)).called(1);
      });

      test('rethrows other exceptions', () async {
        // Previous state: reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 1,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        // Optimistic state: not reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Mock delete to throw different exception
        when(() => mockDeleteRepost.call(myRepostRef)).thenThrow(Exception('Network error'));

        // Execute and expect exception
        expect(
          () => strategy.send(previous, optimistic),
          throwsA(isA<Exception>()),
        );

        // Verify cache was not invalidated
        verifyNever(() => mockInvalidateCache.call(any()));
      });

      test('successful delete with zero count', () async {
        // Previous state: reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 1,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        // Optimistic state: not reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Mock successful delete
        when(() => mockDeleteRepost.call(myRepostRef)).thenAnswer((_) async {});

        // Execute
        final result = await strategy.send(previous, optimistic);

        // Verify result
        expect(result.repostedByMe, isFalse);
        expect(result.myRepostReference, isNull);
        expect(result.repostsCount, 0);

        // Verify cache was invalidated twice (once normally, once for count=0)
        verify(() => mockInvalidateCache.call(eventRef)).called(2);
      });
    });

    group('create repost scenarios', () {
      test('successful create', () async {
        const createdRef = ReplaceableEventReference(
          kind: 16,
          masterPubkey: 'newPubkey',
          dTag: 'newTag',
        );

        // Previous state: not reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Optimistic state: reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 1,
          quotesCount: 0,
          repostedByMe: true,
        );

        // Mock successful create
        when(() => mockCreateRepost.call(eventRef)).thenAnswer((_) async => createdRef);

        // Execute
        final result = await strategy.send(previous, optimistic);

        // Verify result
        expect(result.repostedByMe, isTrue);
        expect(result.myRepostReference, createdRef);
        expect(result.repostsCount, 1);

        // Verify cache was invalidated once
        verify(() => mockInvalidateCache.call(eventRef)).called(1);
      });

      test('create failure throws exception', () async {
        // Previous state: not reposted
        const previous = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        // Optimistic state: reposted
        const optimistic = PostRepost(
          eventReference: eventRef,
          repostsCount: 1,
          quotesCount: 0,
          repostedByMe: true,
        );

        // Mock create failure
        when(() => mockCreateRepost.call(eventRef)).thenThrow(Exception('Create failed'));

        // Execute and expect exception
        expect(
          () => strategy.send(previous, optimistic),
          throwsA(isA<Exception>()),
        );

        // Verify cache was not invalidated
        verifyNever(() => mockInvalidateCache.call(any()));
      });
    });

    test('no action when states are the same', () async {
      // Both states are the same
      const state = PostRepost(
        eventReference: eventRef,
        repostsCount: 5,
        quotesCount: 2,
        repostedByMe: true,
        myRepostReference: myRepostRef,
      );

      // Execute
      final result = await strategy.send(state, state);

      // Verify result is unchanged
      expect(result, state);

      // Verify no methods were called
      verifyNever(() => mockCreateRepost.call(any()));
      verifyNever(() => mockDeleteRepost.call(any()));
      verifyNever(() => mockInvalidateCache.call(any()));
    });
  });
}
