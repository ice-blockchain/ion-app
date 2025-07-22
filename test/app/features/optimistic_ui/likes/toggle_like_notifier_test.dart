// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.r.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_service.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.f.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/post_like_provider.r.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/toggle_like_intent.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_utils.dart';

class _MockOptimisticService extends Mock implements OptimisticService<PostLike> {}

void main() {
  setUpAll(() {
    registerFallbackValue(ToggleLikeIntent());
    registerFallbackValue(
      const PostLike(
        eventReference: ImmutableEventReference(
          masterPubkey: 'test',
          eventId: 'test',
          kind: 1,
        ),
        likesCount: 0,
        likedByMe: false,
      ),
    );
  });

  group('ToggleLikeNotifier', () {
    late _MockOptimisticService mockService;

    const eventRef = ImmutableEventReference(
      masterPubkey: 'pubkey123',
      eventId: 'event123',
      kind: 1,
    );

    setUp(() {
      mockService = _MockOptimisticService();
      when(() => mockService.dispatch(any(), any())).thenAnswer((_) async {});
    });

    test('prevents multiple simultaneous toggle operations for already liked content', () async {
      final container = createContainer(
        overrides: [
          postLikeServiceProvider.overrideWithValue(mockService),
          postLikeWatchProvider(eventRef.toString()).overrideWith(
            (ref) => Stream.value(
              const PostLike(
                eventReference: eventRef,
                likesCount: 5,
                likedByMe: true,
              ),
            ),
          ),
          likesCountProvider(eventRef).overrideWithValue(5),
          isLikedProvider(eventRef).overrideWithValue(true),
        ],
      );

      final notifier = container.read(toggleLikeNotifierProvider.notifier);

      final futures = List.generate(5, (_) => notifier.toggle(eventRef));

      await Future.wait(futures);

      verify(() => mockService.dispatch(any(), any())).called(1);
    });

    test('allows toggle operations for different content simultaneously', () async {
      const eventRef2 = ImmutableEventReference(
        masterPubkey: 'pubkey456',
        eventId: 'event456',
        kind: 1,
      );

      final container = createContainer(
        overrides: [
          postLikeServiceProvider.overrideWithValue(mockService),
          postLikeWatchProvider(eventRef.toString()).overrideWith(
            (ref) => Stream.value(
              const PostLike(
                eventReference: eventRef,
                likesCount: 5,
                likedByMe: true,
              ),
            ),
          ),
          postLikeWatchProvider(eventRef2.toString()).overrideWith(
            (ref) => Stream.value(
              const PostLike(
                eventReference: eventRef2,
                likesCount: 3,
                likedByMe: true,
              ),
            ),
          ),
          likesCountProvider(eventRef).overrideWithValue(5),
          likesCountProvider(eventRef2).overrideWithValue(3),
          isLikedProvider(eventRef).overrideWithValue(true),
          isLikedProvider(eventRef2).overrideWithValue(true),
        ],
      );

      final notifier = container.read(toggleLikeNotifierProvider.notifier);

      final future1 = notifier.toggle(eventRef);
      final future2 = notifier.toggle(eventRef2);

      await Future.wait([future1, future2]);

      verify(() => mockService.dispatch(any(), any())).called(2);
    });

    test('allows subsequent toggle after debounce period', () async {
      final container = createContainer(
        overrides: [
          postLikeServiceProvider.overrideWithValue(mockService),
          postLikeWatchProvider(eventRef.toString()).overrideWith(
            (ref) => Stream.value(
              const PostLike(
                eventReference: eventRef,
                likesCount: 5,
                likedByMe: true,
              ),
            ),
          ),
          likesCountProvider(eventRef).overrideWithValue(5),
          isLikedProvider(eventRef).overrideWithValue(true),
        ],
      );

      final notifier = container.read(toggleLikeNotifierProvider.notifier);

      await notifier.toggle(eventRef);
      verify(() => mockService.dispatch(any(), any())).called(1);

      unawaited(notifier.toggle(eventRef));
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await notifier.toggle(eventRef);

      verify(() => mockService.dispatch(any(), any())).called(2);
    });

    test('debounce delay is at least 300ms', () async {
      final container = createContainer(
        overrides: [
          postLikeServiceProvider.overrideWithValue(mockService),
          postLikeWatchProvider(eventRef.toString()).overrideWith(
            (ref) => Stream.value(
              const PostLike(
                eventReference: eventRef,
                likesCount: 5,
                likedByMe: true,
              ),
            ),
          ),
          likesCountProvider(eventRef).overrideWithValue(5),
          isLikedProvider(eventRef).overrideWithValue(true),
        ],
      );

      final notifier = container.read(toggleLikeNotifierProvider.notifier);

      final stopwatch = Stopwatch()..start();

      await notifier.toggle(eventRef);

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));
    });
  });
}
