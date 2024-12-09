// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_count_provider.c.g.dart';

@riverpod
class RepliesCount extends _$RepliesCount {
  @override
  int? build(EventReference eventReference) {
    final entity = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: eventReference.eventId,
            type: EventCountResultType.replies,
          ),
        ),
      ),
    );
    return entity?.data.content as int?;
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
