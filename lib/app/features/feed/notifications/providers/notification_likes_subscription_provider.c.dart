// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/event_syncer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_likes_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationLikesSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final likesRepository = ref.watch(likesRepositoryProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestFilter = RequestFilter(
    kinds: const [ReactionEntity.kind],
    tags: {
      '#p': [currentPubkey],
    },
    since: DateTime.now().subtract(const Duration(microseconds: 2)).microsecondsSinceEpoch,
  );

  final lastCreatedAt = await likesRepository.lastCreatedAt();

  final since = await ref.watch(eventSyncerProvider('notifications-likes').notifier).syncEvents(
    requestFilters: [requestFilter],
    sinceDateMicroseconds: lastCreatedAt?.microsecondsSinceEpoch,
    saveCallback: (eventMessage) {
      final parser = ref.read(eventParserProvider);
      final entity = parser.parse(eventMessage);

      if (entity.masterPubkey != currentPubkey) {
        likesRepository.save(entity);
      }
    },
  );

  final requestMessage = RequestMessage()..addFilter(requestFilter.copyWith(since: () => since));

  final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

  final subscription =
      entities.where((entity) => entity.masterPubkey != currentPubkey).listen(likesRepository.save);

  ref.onDispose(subscription.cancel);
}
