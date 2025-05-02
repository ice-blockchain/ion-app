// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_count_provider.c.g.dart';

@riverpod
class RepliesCount extends _$RepliesCount {
  @override
  int build(EventReference eventReference) {
    final cacheCount = ref
            .watch(
              ionConnectCacheProvider.select(
                cacheSelector<EventCountResultEntity>(
                  EventCountResultEntity.cacheKeyBuilder(
                    key: eventReference.toString(),
                    type: EventCountResultType.replies,
                  ),
                ),
              ),
            )
            ?.data
            .content as int? ??
        0;

    return cacheCount;
  }
}

class RepliesCountService {
  RepliesCountService(this.ref);
  final Ref ref;

  Future<void> incrementReplies(EventReference eventReference) async {
    final cache = ref.read(ionConnectCacheProvider);
    final key = '$eventReference:replies';
    final entry = cache[key];
    if (entry == null) {
      return;
    }
    final entity = entry.entity as EventCountResultEntity;
    final updatedEntity = entity.copyWith(
      data: entity.data.copyWith(
        content: (entity.data.content as int) + 1,
      ),
    );
    ref.read(ionConnectCacheProvider.notifier).cache(updatedEntity);
    ref.invalidate(repliesCountProvider(eventReference));
  }

  Future<void> decrementReplies(EventReference eventReference) async {
    final cache = ref.read(ionConnectCacheProvider);
    final key = '$eventReference:replies';
    final entry = cache[key];
    if (entry == null) {
      return;
    }
    final entity = entry.entity as EventCountResultEntity;
    final updatedEntity = entity.copyWith(
      data: entity.data.copyWith(
        content: (entity.data.content as int) - 1,
      ),
    );
    ref.read(ionConnectCacheProvider.notifier).cache(updatedEntity);
    ref.invalidate(repliesCountProvider(eventReference));
  }
}
