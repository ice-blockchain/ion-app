// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mutual_followers_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? mutualFollowersDataSource(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null || pubkey == currentPubkey) {
    return null;
  }

  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is FollowListEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [FollowListEntity.kind],
          p: [pubkey, currentPubkey],
          search: SearchExtensions(
            [
              MostRelevantFollowersSearchExtension(),
              GenericIncludeSearchExtension(
                forKind: FollowListEntity.kind,
                includeKind: UserMetadataEntity.kind,
              ),
            ],
          ).toString(),
          limit: 3,
        ),
      ],
    ),
  ];
}
