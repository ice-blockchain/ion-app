// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/event_syncer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_quotes_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationQuotesSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final commentsRepository = ref.watch(commentsRepositoryProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestFilter = RequestFilter(
    kinds: const [ModifiablePostEntity.kind],
    tags: {
      '#Q': [
        [null, null, currentPubkey],
      ],
    },
  );

  final lastCreatedAt = await commentsRepository.lastCreatedAt(CommentIonNotificationType.quote);

  final latestSyncedEventTimestamp =
      await ref.watch(eventSyncerProvider('notifications-quotes').notifier).syncEvents(
    requestFilters: [requestFilter],
    sinceDateMicroseconds: lastCreatedAt?.microsecondsSinceEpoch,
    saveCallback: (eventMessage) {
      final parser = ref.read(eventParserProvider);
      final entity = parser.parse(eventMessage);

      if (entity.masterPubkey != currentPubkey) {
        commentsRepository.save(entity);
      }
    },
  );

  final requestMessage = RequestMessage()
    ..addFilter(requestFilter.copyWith(since: () => latestSyncedEventTimestamp));

  final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

  final subscription = entities
      .where((entity) => entity.masterPubkey != currentPubkey)
      .listen(commentsRepository.save);

  ref.onDispose(subscription.cancel);
}
