// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? userPostsDataSource(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (currentPubkey == null) {
    return null;
  }

  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) =>
          entity.masterPubkey == pubkey &&
          (entity is ModifiablePostEntity || entity is GenericRepostEntity),
      requestFilters: [
        RequestFilter(
          kinds: const [ModifiablePostEntity.kind, GenericRepostEntity.kind],
          authors: [pubkey],
          search: SearchExtensions.withCounters(
            [
              ReferencesSearchExtension(contain: false),
              ExpirationSearchExtension(expiration: false),
            ],
            currentPubkey: currentPubkey,
          ).toString(),
          limit: 10,
        ),
      ],
    ),
  ];
}
