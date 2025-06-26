// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/follow_list.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/badges_notifier.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_data_source_provider.r.g.dart';

@riverpod
List<EntitiesDataSource>? followersDataSource(
  Ref ref,
  String pubkey, {
  String? query,
}) {
  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is UserMetadataEntity || entity is FollowListEntity,
      pagedFilter: (entity) => entity is FollowListEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [FollowListEntity.kind],
          tags: {
            '#p': [pubkey],
          },
          search: SearchExtensions(
            [
              if (query != null) QuerySearchExtension(searchQuery: query),
              GenericIncludeSearchExtension(
                forKind: FollowListEntity.kind,
                includeKind: UserMetadataEntity.kind,
              ),
              if (ref.watch(cachedProfileBadgesDataProvider(pubkey)) == null)
                ProfileBadgesSearchExtension(forKind: FollowListEntity.kind),
            ],
          ).toString(),
          limit: 20,
        ),
      ],
    ),
  ];
}
