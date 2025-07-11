// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:ion/app/services/ion_connect/ion_connect_relays_ranker.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranked_user_relays_provider.r.g.dart';

/// Ranked relays are the relays that are sorted based on their latency.
///
/// Latency is measured by pinging the relays (check [ionConnectRelaysRankerProvider] for details).

@Riverpod(keepAlive: true)
Future<UserRelaysEntity?> rankedCurrentUserRelays(Ref ref) async {
  final currentUserRelayEntity = await ref.watch(currentUserRelaysProvider.future);

  final pingIntervalSeconds =
      ref.read(envProvider.notifier).get<int>(EnvVariable.RELAY_PING_INTERVAL_SECONDS);
  final timer = Timer.periodic(Duration(seconds: pingIntervalSeconds), (_) {
    ref.invalidate(rankedRelayProvider(currentUserRelayEntity));
  });
  ref.onDispose(timer.cancel);

  return ref.watch(rankedRelayProvider(currentUserRelayEntity).future);
}

@riverpod
Future<UserRelaysEntity?> rankedRelay(
  Ref ref,
  UserRelaysEntity? relayEntity,
) async {
  if (relayEntity == null) {
    return null;
  }
  final cancelToken = CancelToken();
  final relaysUrls = relayEntity.data.list.map((e) => e.url).toList();
  final rankedRelaysUrls = await ref.watch(ionConnectRelaysRankerProvider).ranked(
        relaysUrls,
        cancelToken: cancelToken,
      );
  final rankedRelays = rankedRelaysUrls
      .map((url) => relayEntity.data.list.firstWhereOrNull((e) => e.url == url))
      .nonNulls
      .toList();

  final updatedRelayEntity = relayEntity.copyWith(
    data: relayEntity.data.copyWith(list: rankedRelays),
  );
  return updatedRelayEntity;
}

@riverpod
Future<List<String>> rankedRelayUrls(Ref ref, List<String>? relaysUrls) async {
  if (relaysUrls == null || relaysUrls.isEmpty) {
    return [];
  }
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(ionConnectRelaysRankerProvider).ranked(relaysUrls, cancelToken: cancelToken);
}
