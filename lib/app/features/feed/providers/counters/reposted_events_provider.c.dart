// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reposted_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Set<String>?> repostedEvents(Ref ref) async* {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);

  if (currentPubkey == null) {
    yield {};
  } else {
    final cache = ref.read(ionConnectCacheProvider);
    var repostedIds = cache.values.fold<Set<String>>({}, (result, entry) {
      final repostedId = _getCurrentUserRepostedId(entry, currentPubkey: currentPubkey);
      if (repostedId != null) {
        result.add(repostedId);
      }
      return result;
    });

    yield repostedIds;

    await for (final entity in ref.watch(ionConnectCacheStreamProvider)) {
      final repostedId = _getCurrentUserRepostedId(entity, currentPubkey: currentPubkey);
      if (repostedId != null) {
        yield repostedIds = {...repostedIds, repostedId};
      }
    }
  }
}

String? _getCurrentUserRepostedId(IonConnectEntity entity, {required String currentPubkey}) {
  if (entity.masterPubkey != currentPubkey) {
    return null;
  }

  if (entity is ModifiablePostEntity && entity.data.quotedEvent != null) {
    return entity.data.quotedEvent!.eventReference.toString();
  } else if (entity is GenericRepostEntity) {
    return entity.data.eventReference.toString();
  } else {
    return null;
  }
}

@riverpod
bool isReposted(Ref ref, EventReference eventReference) {
  if (eventReference is! ReplaceableEventReference) {
    throw UnsupportedEventReference(eventReference);
  }
  return ref.watch(repostedEventsProvider).valueOrNull?.contains(eventReference.toString()) ??
      false;
}
