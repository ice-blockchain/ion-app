// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/reaction_data.dart';
import 'package:ion/app/features/feed/providers/counters/is_liked_provider.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifier.g.dart';

@riverpod
class LikesNotifier extends _$LikesNotifier {
  @override
  FutureOr<void> build(EventReference eventReference) {}

  Future<void> toggle() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final isLiked = ref.read(isLikedProvider(eventReference));

      if (isLiked) {
        throw UnimplementedError();
      } else {
        final data = ReactionData(
          content: ReactionEntity.likeSymbol,
          eventId: eventReference.eventId,
          pubkey: eventReference.pubkey,
        );
        await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
      }
    });
  }
}
