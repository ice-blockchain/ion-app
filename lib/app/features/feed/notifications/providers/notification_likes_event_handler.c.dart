// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_persistent_subscription.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_likes_event_handler.c.g.dart';

class NotificationLikesEventHandler extends PersistentSubscriptionEventHandler {
  NotificationLikesEventHandler(this.likesRepository, this.currentPubkey);

  final LikesRepository likesRepository;
  final String currentPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == ReactionEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = ReactionEntity.fromEventMessage(eventMessage);
    final isOwnReaction = entity.masterPubkey == currentPubkey;
    if (!isOwnReaction) {
      await likesRepository.save(entity);
    }
  }
}

@riverpod
NotificationLikesEventHandler notificationLikesEventHandler(Ref ref) {
  final likesRepository = ref.watch(likesRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return NotificationLikesEventHandler(likesRepository, currentPubkey);
}
