// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.r.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.r.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/repost_sync_strategy.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_sync_strategy_provider.r.g.dart';

@riverpod
SyncStrategy<PostRepost> repostSyncStrategy(Ref ref) {
  final repostNotifier = ref.read(repostNotifierProvider.notifier);
  final deleteController = ref.read(deleteEntityControllerProvider.notifier);
  final cacheNotifier = ref.read(ionConnectCacheProvider.notifier);

  return RepostSyncStrategy(
    createRepost: (eventReference) async {
      final createdEntity = await repostNotifier.repost(eventReference: eventReference);
      final createdRef = createdEntity.toEventReference();
      return createdRef;
    },
    deleteRepost: (repostReference) async {
      await deleteController.deleteByReference(repostReference);
    },
    invalidateCounterCache: (eventReference) {
      final repostsCacheKey = EventCountResultEntity.cacheKeyBuilder(
        key: eventReference.toString(),
        type: EventCountResultType.reposts,
      );
      final quotesCacheKey = EventCountResultEntity.cacheKeyBuilder(
        key: eventReference.toString(),
        type: EventCountResultType.quotes,
      );

      cacheNotifier
        ..remove(repostsCacheKey)
        ..remove(quotesCacheKey);
    },
  );
}
