// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/providers/count_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_members_count_provider.c.g.dart';

@riverpod
FutureOr<int?> communityMembersCount(
  Ref ref, {
  required CommunityDefinitionEntity community,
}) async {
  final userRelays = await ref.read(userRelayProvider(community.ownerPubkey).future);
  if (userRelays == null) {
    throw UserRelaysNotFoundException();
  }

  final relayUrl = userRelays.data.list.random.url;
  final relay = await ref.read(relayProvider(relayUrl).future);

  final filters = [
    RequestFilter(
      kinds: const [CommunityJoinEntity.kind],
      tags: {
        '#h': [community.data.uuid],
      },
    ),
  ];

  final getCommunityCreationCacheMinutes =
      ref.read(envProvider.notifier).get<int>(EnvVariable.COMMUNITY_CREATION_CACHE_MINUTES);
  final canUseCache = community.createdAt
      .add(Duration(minutes: getCommunityCreationCacheMinutes))
      .isAfter(DateTime.now());

  Duration? getCommunityMembersCountCacheMinutes;
  if (canUseCache) {
    getCommunityMembersCountCacheMinutes = Duration(
      minutes: ref
          .read(envProvider.notifier)
          .get<int>(EnvVariable.COMMUNITY_MEMBERS_COUNT_CACHE_MINUTES),
    );
  }

  return ref.watch(
    countProvider(
      key: community.data.uuid,
      relay: relay,
      type: EventCountResultType.members,
      filters: filters,
      cacheExpirationDuration: getCommunityMembersCountCacheMinutes,
    ).future,
  ) as FutureOr<int?>;
}
