// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_details_refresher.c.g.dart';

//TODO:rename to PostWithDependencies and method fetch - use in the Post component
// ionConnectSyncEntityProvider -> ionConnectCachedEntityProvider
// test - check if counters and other deps are fetched for reposted / quoted posts
@riverpod
class PostDetailsRefresher extends _$PostDetailsRefresher {
  @override
  FutureOr<void> build(EventReference eventReference) {}

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final currentUserPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentUserPubkey == null) {
        throw const CurrentUserNotFoundException();
      }

      final search = SearchExtensions([
        ...SearchExtensions.withCounters(
          [],
          currentPubkey: currentUserPubkey,
          // forKind: PostEntity.kind, //TODO:set
          root: false,
        ).extensions,
      ]).toString();

      ref.read(ionConnectNetworkEntityProvider(eventReference: eventReference, search: search));
    });
  }
}
