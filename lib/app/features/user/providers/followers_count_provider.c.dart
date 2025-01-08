// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_count_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<int?> followersCount(Ref ref, String pubkey) async {
  final followersCountEntity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(
        EventCountResultEntity.cacheKeyBuilder(
          key: pubkey,
          type: EventCountResultType.followers,
        ),
      ),
    ),
  );

  if (followersCountEntity != null) {
    return 0;
  }

  // TODO:uncomment when impl
  // final followersCountRequest = EventCountRequestData(
  //   params: const EventCountRequestParams(group: 'p'),
  //   filters: [
  //     RequestFilter(kinds: const [FollowListEntity.kind], p: [pubkey]),
  //   ],
  // );

  // final response = await ref.read(ionConnectNotifierProvider.notifier).requestCount(
  //       followersCountRequest,
  //       actionSource: ActionSourceUser(pubkey),
  //     );

  return Random().nextInt(100);
}
