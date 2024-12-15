// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_data_source_provider.c.g.dart';

@Riverpod(dependencies: [nostrEntity])
List<EntitiesDataSource>? repliesDataSource(
  Ref ref, {
  required EventReference eventReference,
}) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final entity = ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull;

  if (currentPubkey == null || entity == null) {
    return null;
  }

  if (entity is! PostEntity) {
    throw IncorrectEventKindException(eventId: eventReference.eventId, kind: PostEntity.kind);
  }

  final dataSources = [
    EntitiesDataSource(
      actionSource: ActionSourceUser(eventReference.pubkey),
      entityFilter: (entity) =>
          entity is PostEntity && entity.data.parentEvent?.eventId == eventReference.eventId,
      requestFilters: [
        RequestFilter(
          kinds: const [PostEntity.kind],
          e: [eventReference.eventId],
          search: SearchExtensions.withCounters(
            [
              ExpirationSearchExtension(expiration: false),
              TagMarkerSearchExtension(
                tagName: RelatedEvent.tagName,
                marker: RelatedEventMarker.reply.toShortString(),
                negative: entity.data.parentEvent == null,
              ),
            ],
            currentPubkey: currentPubkey,
            root: false,
          ).toString(),
          limit: 10,
        ),
      ],
    ),
  ];

  return dataSources;
}
