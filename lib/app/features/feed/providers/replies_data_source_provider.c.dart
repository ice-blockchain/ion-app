// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? repliesDataSource(
  Ref ref, {
  required EventReference eventReference,
}) {
  final dataSources = [
    EntitiesDataSource(
      actionSource: ActionSourceUser(eventReference.pubkey),
      entityFilter: (entity) => entity is PostEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [PostEntity.kind],
          e: [eventReference.eventId, '', 'reply'],
          search: SearchExtensions.withCounters(
            [
              ExpirationSearchExtension(expiration: false),
            ],
            root: false,
          ).toString(),
          limit: 10,
        ),
      ],
    ),
  ];

  return dataSources;
}
