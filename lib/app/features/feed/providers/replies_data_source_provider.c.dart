// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? repliesDataSource(
  Ref ref, {
  required EventReference eventReference,
}) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final entity = ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

  if (currentPubkey == null || entity == null) {
    return null;
  }

  final dataSources = [
    EntitiesDataSource(
      actionSource: ActionSourceUser(eventReference.pubkey),
      entityFilter: (entity) =>
          (entity is ModifiablePostEntity &&
              entity.data.parentEvent?.eventReference == eventReference) ||
          (entity is PostEntity && entity.data.parentEvent?.eventReference == eventReference),
      requestFilters: [
        RequestFilter(
          kinds: const [ModifiablePostEntity.kind],
          tags: Map.fromEntries([eventReference.toFilterEntry()]),
          search: SearchExtensions(
            [
              ...SearchExtensions.withCounters(
                [
                  GenericIncludeSearchExtension(
                    forKind: ModifiablePostEntity.kind,
                    includeKind: UserMetadataEntity.kind,
                  ),
                  GenericIncludeSearchExtension(
                    forKind: ModifiablePostEntity.kind,
                    includeKind: BlockListEntity.kind,
                  ),
                ],
                currentPubkey: currentPubkey,
              ).extensions,
              ExpirationSearchExtension(expiration: false),
            ],
          ).toString(),
          limit: 10,
        ),
        RequestFilter(
          kinds: const [PostEntity.kind],
          tags: Map.fromEntries([eventReference.toFilterEntry()]),
          search: SearchExtensions(
            [
              ...SearchExtensions.withCounters(
                [
                  GenericIncludeSearchExtension(
                    forKind: PostEntity.kind,
                    includeKind: UserMetadataEntity.kind,
                  ),
                  GenericIncludeSearchExtension(
                    forKind: PostEntity.kind,
                    includeKind: BlockListEntity.kind,
                  ),
                ],
                currentPubkey: currentPubkey,
                forKind: PostEntity.kind,
              ).extensions,
              ExpirationSearchExtension(expiration: false),
            ],
          ).toString(),
          limit: 10,
        ),
      ],
    ),
  ];

  return dataSources;
}
