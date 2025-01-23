// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_repost_provider.c.g.dart';

@riverpod
Future<EventReference?> currentUserRepost(Ref ref, EventReference eventReference) async {
  if (eventReference is! ReplaceableEventReference) {
    throw UnsupportedEventReference(eventReference);
  }

  final currentUserPubkey = await ref.watch(currentPubkeySelectorProvider.future);
  if (currentUserPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final cache = ref.watch(ionConnectCacheProvider);

  final cacheableEntity = cache.values.firstWhereOrNull(
    (entity) =>
        entity is GenericRepostEntity &&
        entity.masterPubkey == currentUserPubkey &&
        entity.data.eventReference == eventReference,
  ) as GenericRepostEntity?;

  return cacheableEntity?.toEventReference();
}
