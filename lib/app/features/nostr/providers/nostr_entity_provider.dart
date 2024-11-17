// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nostr_entity_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Future<NostrEntity?> nostrEntity(
  Ref ref, {
  required EventReference eventReference,
}) async {
  final entity = ref.watch(nostrCacheProvider.select(cacheSelector(eventReference.eventId)));
  if (entity != null) {
    return entity;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(ids: [eventReference.eventId], limit: 1));
  return ref.read(nostrNotifierProvider.notifier).requestEntity(
        requestMessage,
        actionSource: ActionSourceUser(eventReference.pubkey),
      );
}
