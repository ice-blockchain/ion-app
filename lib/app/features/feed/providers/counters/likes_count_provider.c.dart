// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_count_provider.c.g.dart';

@riverpod
class LikesCount extends _$LikesCount {
  @override
  int? build(EventReference eventReference) {
    final reactionsCountEntity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.reactions,
          ),
        ),
      ),
    );

    if (reactionsCountEntity == null) {
      return null;
    }

    final content = reactionsCountEntity.data.content as Map<String, dynamic>;
    return (content[ReactionEntity.likeSymbol] ?? 0) as int;
  }

  void addOne() {
    if (state != null) {
      state = state! + 1;
    }
  }

  void removeOne() {
    if (state != null) {
      state = state! - 1;
    }
  }
}
