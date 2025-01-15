// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
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
    return followersCountEntity.data.content as int;
  }

  final userRelays = await ref.read(currentUserRelayProvider.future);
  if (userRelays == null) {
    throw UserRelaysNotFoundException();
  }

  final relayUrl = userRelays.data.list.random.url;

  final followersCountRequest = EventCountRequestData(
    relays: [relayUrl],
    params: const EventCountRequestParams(group: 'p'),
    filters: [
      RequestFilter(kinds: const [FollowListEntity.kind], p: [pubkey]),
    ],
  );

  final followersCountRequestEvent =
      await ref.read(ionConnectNotifierProvider.notifier).sign(followersCountRequest);

  await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
        followersCountRequestEvent,
        actionSource: ActionSourceRelayUrl(relayUrl),
        cache: false,
      );

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [EventCountResultEntity.kind],
        e: [followersCountRequestEvent.id],
        limit: 1,
      ),
    );

  final foo = await ref
      .read(ionConnectNotifierProvider.notifier)
      .requestEntity(requestMessage, actionSource: ActionSourceRelayUrl(relayUrl));
  // ignore: avoid_print
  print(foo);
  throw Exception('1');
  // return response.data.content as int;
}
