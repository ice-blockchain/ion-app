// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_entity_provider.c.g.dart';

@riverpod
Future<IonConnectEntity?> ionConnectEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
}) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }

  if (cache) {
    final entity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
      ),
    );
    if (entity != null) {
      return entity;
    }
  }

  if (network) {
    if (eventReference is ImmutableEventReference) {
      final requestMessage = RequestMessage()
        ..addFilter(RequestFilter(ids: [eventReference.eventId], limit: 1));
      return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
            requestMessage,
            actionSource: ActionSourceUser(eventReference.pubkey),
          );
    } else if (eventReference is ReplaceableEventReference) {
      final requestMessage = RequestMessage()
        ..addFilter(
          RequestFilter(
            kinds: [eventReference.kind],
            authors: [eventReference.pubkey],
            tags: {
              if (eventReference.dTag != null) '#d': [eventReference.dTag.toString()],
            },
            limit: 1,
          ),
        );
      return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
            requestMessage,
            actionSource: ActionSourceUser(eventReference.pubkey),
          );
    } else {
      throw UnsupportedEventReference(eventReference);
    }
  }

  return null;
}

@riverpod
IonConnectEntity? cachedIonConnectEntity(
  Ref ref, {
  required EventReference eventReference,
}) =>
    ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
      ),
    );
