// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/likes/model/post_like.dart';
import 'package:ion/app/features/feed/likes/providers/optimistic_likes_manager.c.dart';
import 'package:ion/app/features/feed/providers/counters/like_reaction_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/likes_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifier.c.g.dart';

@riverpod
class LikesNotifier extends _$LikesNotifier {
  @override
  FutureOr<void> build(EventReference eventReference) {}

  Future<void> toggle() async {
    final manager = ref.read(optimisticLikesManagerProvider);

    var current = manager.snapshot.firstWhereOrNull(
      (p) => p.optimisticId == eventReference.toString(),
    );

    current ??= PostLike(
      eventReference: eventReference,
      likesCount: ref.read(likesCountProvider(eventReference)),
      likedByMe: ref.read(isLikedProvider(eventReference)),
    );

    final toggledLiked = !current.likedByMe;
    final nextCount = current.likesCount + (toggledLiked ? 1 : -1);

    final optimistic = current.copyWith(likedByMe: toggledLiked, likesCount: nextCount);

    await manager.perform(previous: current, optimistic: optimistic);

    state = const AsyncValue.data(null);
  }
}
