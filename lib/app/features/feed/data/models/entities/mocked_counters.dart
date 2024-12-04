// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

void generateFakeCounters(Ref ref, String eventId) {
  final requestEventReplies = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountRequestEntity.kind,
    content: RequestFilter(kinds: const [1, 6], e: [eventId]).toString(),
    tags: const [
      ['param', 'group', 'root'],
      ['b', ''],
    ],
  );

  final responseEventReplies = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountResultEntity.kind,
    content: Random().nextInt(10000).toString(),
    tags: [
      ['request', requestEventReplies.toString()],
      ['e', requestEventReplies.id],
      ['p', requestEventReplies.pubkey],
      const ['b', ''],
    ],
  );
  final repliesCountEntity = EventCountResultEntity.fromEventMessage(responseEventReplies);
  ref.read(nostrCacheProvider.notifier).cache(repliesCountEntity);

  final requestEventReposts = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountRequestEntity.kind,
    content: RequestFilter(kinds: const [6], e: [eventId]).toString(),
    tags: const [
      ['param', 'group', 'e'],
      ['b', ''],
    ],
  );
  final responseEventReposts = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountResultEntity.kind,
    content: Random().nextInt(1000).toString(),
    tags: [
      ['request', requestEventReposts.toString()],
      ['e', requestEventReposts.id],
      ['p', requestEventReposts.pubkey],
      const ['b', ''],
    ],
  );
  final repostsCountEntity = EventCountResultEntity.fromEventMessage(responseEventReposts);
  ref.read(nostrCacheProvider.notifier).cache(repostsCountEntity);

  final requestEventQuotes = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountRequestEntity.kind,
    content: RequestFilter(kinds: const [1], q: [eventId]).toString(),
    tags: const [
      ['param', 'group', 'q'],
      ['b', ''],
    ],
  );
  final responseEventQuotes = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountResultEntity.kind,
    content: Random().nextInt(1000).toString(),
    tags: [
      ['request', requestEventQuotes.toString()],
      ['e', requestEventQuotes.id],
      ['p', requestEventQuotes.pubkey],
      const ['b', ''],
    ],
  );
  final quotesCountEntity = EventCountResultEntity.fromEventMessage(responseEventQuotes);
  ref.read(nostrCacheProvider.notifier).cache(quotesCountEntity);

  final requestEventReactions = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountRequestEntity.kind,
    content: RequestFilter(kinds: const [7], e: [eventId]).toString(),
    tags: const [
      ['param', 'group', 'content'],
      ['b', ''],
    ],
  );
  final responseEventReactions = EventMessage(
    id: '-',
    pubkey: '-',
    createdAt: DateTime.now(),
    sig: '-',
    kind: EventCountResultEntity.kind,
    content: '{"+":${Random().nextInt(1000)}}',
    tags: [
      ['request', requestEventReactions.toString()],
      ['e', requestEventReactions.id],
      ['p', requestEventReactions.pubkey],
      const ['b', ''],
    ],
  );
  final reactionsCountEntity = EventCountResultEntity.fromEventMessage(responseEventReactions);
  ref.read(nostrCacheProvider.notifier).cache(reactionsCountEntity);
}
