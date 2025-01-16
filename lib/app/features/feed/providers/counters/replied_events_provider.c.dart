// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replied_events_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<Set<String>?> repliedEvents(Ref ref) async* {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);

  if (currentPubkey == null) {
    yield {};
  } else {
    final cache = ref.read(ionConnectCacheProvider);
    var repliedIds = cache.values.fold<Set<String>>({}, (result, entry) {
      final currentUserRepliedIds = _getCurrentUserRepliedIds(entry, currentPubkey: currentPubkey);
      if (currentUserRepliedIds != null) {
        result.addAll(currentUserRepliedIds);
      }
      return result;
    });

    yield repliedIds;

    await for (final entity in ref.watch(ionConnectCacheStreamProvider)) {
      final currentUserRepliedIds = _getCurrentUserRepliedIds(entity, currentPubkey: currentPubkey);
      if (currentUserRepliedIds != null) {
        yield repliedIds = {...repliedIds, ...currentUserRepliedIds};
      }
    }
  }
}

List<String>? _getCurrentUserRepliedIds(IonConnectEntity entity, {required String currentPubkey}) {
  if (entity.masterPubkey != currentPubkey || entity is! PostEntity) {
    return null;
  }

  final relatedEvents = entity.data.relatedEvents;

  if (relatedEvents == null) {
    return null;
  }

  return [
    for (final event in relatedEvents)
      if (event.marker == RelatedEventMarker.reply || event.marker == RelatedEventMarker.root)
        event.eventId,
  ];
}

@riverpod
bool isReplied(Ref ref, EventReference eventReference) {
  return ref.watch(repliedEventsProvider).valueOrNull?.contains(eventReference.eventId) ?? false;
}
