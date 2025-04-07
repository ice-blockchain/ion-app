// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
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

  final hasParent = switch (entity) {
    ArticleEntity() => false,
    ModifiablePostEntity() => entity.data.parentEvent != null,
    PostEntity() => entity.data.parentEvent != null,
    _ => throw UnsupportedEventReference(eventReference)
  };

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
                  TagMarkerSearchExtension(
                    tagName: RelatedReplaceableEvent.tagName,
                    marker: RelatedEventMarker.reply.toShortString(),
                    negative: !hasParent,
                  ),
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
                root: false,
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
                  TagMarkerSearchExtension(
                    tagName: RelatedImmutableEvent.tagName,
                    marker: RelatedEventMarker.reply.toShortString(),
                    negative: !hasParent,
                  ),
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
                root: false,
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
