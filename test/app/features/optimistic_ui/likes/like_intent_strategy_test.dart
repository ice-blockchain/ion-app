// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/like_sync_strategy.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/model/post_like.c.dart';
import 'package:ion/app/features/optimistic_ui/features/likes/toggle_like_intent.dart';
import 'package:mocktail/mocktail.dart';

class _MockReactionEntity extends Mock implements ReactionEntity {}

void main() {
  group('ToggleLikeIntent.optimistic()', () {
    const ref = ImmutableEventReference(
      pubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );
    final intent = ToggleLikeIntent();

    test('adds like if it was not liked', () {
      const prev = PostLike(eventReference: ref, likesCount: 3, likedByMe: false);
      final next = intent.optimistic(prev);

      expect(next.likedByMe, isTrue);
      expect(next.likesCount, 4);
    });

    test('removes like if it was liked', () {
      const prev = PostLike(eventReference: ref, likesCount: 4, likedByMe: true);
      final next = intent.optimistic(prev);

      expect(next.likedByMe, isFalse);
      expect(next.likesCount, 3);
    });
  });

  group('LikeSyncStrategy.send()', () {
    late bool reactionSent;
    late bool deletionSent;
    late String? removedCacheKey;

    LikeSyncStrategy strategy0({
      ReactionEntity? likeEntity,
    }) {
      return LikeSyncStrategy(
        sendReaction: (ReactionData _) async => reactionSent = true,
        getLikeEntity: (_) => likeEntity,
        deleteReaction: (DeletionRequest _) async => deletionSent = true,
        removeFromCache: (key) => removedCacheKey = key,
      );
    }

    setUp(() {
      reactionSent = false;
      deletionSent = false;
      removedCacheKey = null;
    });

    const ref = ImmutableEventReference(
      pubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );

    test('calls sendReaction when toggling to like', () async {
      const prev = PostLike(eventReference: ref, likesCount: 0, likedByMe: false);
      final opt = prev.copyWith(likedByMe: true, likesCount: 1);

      final result = await strategy0().send(prev, opt);

      expect(result, same(opt));
      expect(reactionSent, isTrue);
      expect(deletionSent, isFalse);
      expect(removedCacheKey, isNull);
    });

    test('calls deleteReaction & removeFromCache when unliking', () async {
      final like = _MockReactionEntity();
      when(() => like.id).thenReturn('abc');
      when(() => like.cacheKey).thenReturn('cache/abc');

      const prev = PostLike(eventReference: ref, likesCount: 1, likedByMe: true);
      final opt = prev.copyWith(likedByMe: false, likesCount: 0);

      final strategy = strategy0(likeEntity: like);
      final result = await strategy.send(prev, opt);

      expect(result, same(opt));
      expect(reactionSent, isFalse);
      expect(deletionSent, isTrue);
      expect(removedCacheKey, 'cache/abc');
    });
  });
}
