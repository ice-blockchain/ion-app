// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_entity_with_counters.c.g.dart';

// make it return articles as well (with deps)
// test - check if counters and other deps are fetched for reposted / quoted posts
@riverpod
IonConnectEntity? ionConnectEntityWithCounters(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
}) {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    throw const CurrentUserNotFoundException();
  }
  if (cache) {
    final entity = ref.watch(ionConnectCachedEntityProvider(eventReference: eventReference));
    if (entity != null) {
      return entity;
    }
  }

  final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
  if (currentUserPubkey == null) {
    throw const CurrentUserNotFoundException();
  }

  final search = SearchExtensions([
    ...SearchExtensions.withCounters(
      [],
      currentPubkey: currentUserPubkey,
      forKind: eventReference is ReplaceableEventReference ? eventReference.kind : PostEntity.kind,
      root: false,
    ).extensions,
  ]).toString();

  if (network) {
    return ref
        .watch(ionConnectNetworkEntityProvider(eventReference: eventReference, search: search))
        .valueOrNull;
  }

  return null;
}
