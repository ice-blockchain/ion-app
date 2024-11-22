// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/feed/data/models/entities/reactions_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_count_provider.g.dart';

@riverpod
int? likesCount(Ref ref, EventReference eventReference) {
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

  final content = reactionsCountEntity?.data.content as Map<String, dynamic>?;
  return content?[ReactionsEntity.likeSymbol] as int?;
}
