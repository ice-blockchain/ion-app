// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_relays_ranker.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranked_user_relays_provider.c.g.dart';

@riverpod
Future<UserRelaysEntity?> rankedUserRelay(Ref ref, String pubkey) async {
  final userRelayEntity = await ref.watch(userRelayProvider(pubkey).future);
  return ref.watch(rankedRelayProvider(userRelayEntity).future);
}

@riverpod
Future<UserRelaysEntity?> rankedCurrentUserRelays(Ref ref) async {
  final currentUserRelayEntity = await ref.watch(currentUserRelaysProvider.future);
  return ref.watch(rankedRelayProvider(currentUserRelayEntity).future);
}

@riverpod
Future<UserRelaysEntity?> rankedRelay(Ref ref, UserRelaysEntity? relayEntity) async {
  if (relayEntity == null) {
    return null;
  }
  final relaysUrls = relayEntity.data.list.map((e) => e.url).toList();
  final rankedRelaysUrls = await ref.watch(ionConnectRelaysRankerProvider(relaysUrls)).ranked();
  final rankedRelays = rankedRelaysUrls
      .map(
        (url) => relayEntity.data.list.firstWhereOrNull((e) => e.url == url),
      )
      .nonNulls
      .toList();

  final updatedRelayEntity = relayEntity.copyWith(
    data: relayEntity.data.copyWith(list: rankedRelays),
  );
  return updatedRelayEntity;
}
