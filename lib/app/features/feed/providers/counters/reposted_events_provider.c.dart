// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Set<String>?> repostedEvents(Ref ref) async* {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    yield {};
  } else {
    final cache = ref.read(nostrCacheProvider);
    var repostedIds = cache.values.fold<Set<String>>({}, (result, entity) {
      final repostedId = _getCurrentUserRepostedId(entity, currentPubkey: currentPubkey);
      if (repostedId != null) {
        result.add(repostedId);
      }
      return result;
    });

    yield repostedIds;

    await for (final entity in ref.watch(nostrCacheStreamProvider)) {
      final repostedId = _getCurrentUserRepostedId(entity, currentPubkey: currentPubkey);
      if (repostedId != null) {
        yield repostedIds = {...repostedIds, repostedId};
      }
    }
  }
}

String? _getCurrentUserRepostedId(NostrEntity entity, {required String currentPubkey}) {
  if (entity.masterPubkey != currentPubkey) {
    return null;
  }

  if (entity is PostEntity && entity.data.quotedEvent != null) {
    return entity.data.quotedEvent!.eventId;
  } else if (entity is RepostEntity) {
    return entity.data.eventId;
  } else if (entity is GenericRepostEntity) {
    return entity.data.eventId;
  } else {
    return null;
  }
}

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  return ref.watch(repostedEventsProvider).valueOrNull?.contains(eventReference.eventId) ?? false;
}