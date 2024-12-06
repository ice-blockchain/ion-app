// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notifier.g.dart';

@Riverpod(dependencies: [nostrEntity])
class RepostNotifier extends _$RepostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> repost({
    required EventReference eventReference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final entity = ref.read(nostrEntityProvider(eventReference: eventReference)).valueOrNull;

      if (entity == null) {
        throw EntityNotFoundException(eventReference.eventId);
      }

      final data = switch (entity) {
        _ when entity is PostEntity => RepostData(
            eventId: eventReference.eventId,
            pubkey: eventReference.pubkey,
            repostedEvent: await entity.toEventMessage(entity.data),
          ),
        _ when entity is ArticleEntity => GenericRepostData(
            eventId: eventReference.eventId,
            pubkey: eventReference.pubkey,
            repostedEvent: await entity.toEventMessage(entity.data),
            kind: ArticleEntity.kind,
          ),
        _ => throw UnsupportedRepostException(eventId: eventReference.eventId),
      };

      await ref.read(nostrNotifierProvider.notifier).sendEntityData(data);
      ref.read(repostsCountProvider(eventReference).notifier).addOne();
    });
  }
}
