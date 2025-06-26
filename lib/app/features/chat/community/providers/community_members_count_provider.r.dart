// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.f.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.f.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/user/providers/count_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_members_count_provider.r.g.dart';

@riverpod
FutureOr<int?> communityMembersCount(
  Ref ref, {
  required CommunityDefinitionEntity community,
}) async {
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
  final canUseCache = community.createdAt.toDateTime
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

  return await ref.watch(
    countProvider(
      actionSource: ActionSource.user(community.ownerPubkey),
      requestData: EventCountRequestData(filters: filters),
      key: community.data.uuid,
      type: EventCountResultType.members,
      cacheExpirationDuration: getCommunityMembersCountCacheMinutes,
    ).future,
  ) as FutureOr<int?>;
}
