// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_replies_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationRepliesSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final commentsRepository = ref.watch(commentsRepositoryProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestFilter = RequestFilter(
    kinds: const [ModifiablePostEntity.kind],
    tags: {
      '#p': [currentPubkey],
    },
    search: SearchExtensions([
      TagMarkerSearchExtension(
        tagName: RelatedReplaceableEvent.tagName,
        marker: RelatedEventMarker.reply.toShortString(),
      ),
    ]).toString(),
    since: DateTime.now().subtract(const Duration(microseconds: 2)).microsecondsSinceEpoch,
  );

  await ref.watch(entitiesSyncerNotifierProvider('notifications-replies').notifier).syncEntities(
    requestFilters: [requestFilter],
    saveCallback: (entity) {
      if (entity.masterPubkey != currentPubkey) {
        commentsRepository.save(entity);
      }
    },
    maxCreatedAtBuilder: () => commentsRepository.lastCreatedAt(CommentIonNotificationType.reply),
    minCreatedAtBuilder: (since) =>
        commentsRepository.firstCreatedAt(CommentIonNotificationType.reply, after: since),
  );

  final requestMessage = RequestMessage()..addFilter(requestFilter);

  final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

  final subscription = entities
      .where((entity) => entity.masterPubkey != currentPubkey)
      .listen(commentsRepository.save);

  ref.onDispose(subscription.cancel);
}
