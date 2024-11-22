// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_count_provider.g.dart';

@riverpod
int? repliesCount(Ref ref, EventReference eventReference) {
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
