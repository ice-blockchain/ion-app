// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_persistent_subscription.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_notification_handler.c.g.dart';

class ReplyNotificationHandler extends PersistentSubscriptionEventHandler {
  ReplyNotificationHandler(this.commentsRepository, this.currentPubkey);

  final CommentsRepository commentsRepository;
  final String currentPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    if (eventMessage.kind != ModifiablePostEntity.kind) {
      return false;
    }

    final entity = ModifiablePostEntity.fromEventMessage(eventMessage);
    final isReply = entity.data.relatedEvents?.any(
          (event) =>
              event.marker == RelatedEventMarker.reply &&
              event.eventReference is ReplaceableEventReference,
        ) ??
        false;
    return eventMessage.kind == ModifiablePostEntity.kind && isReply;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = ModifiablePostEntity.fromEventMessage(eventMessage);

    final isOwnReply = entity.masterPubkey == currentPubkey;
    if (!isOwnReply) {
      await commentsRepository.save(entity);
    }
  }
}

@riverpod
ReplyNotificationHandler replyNotificationHandler(Ref ref) {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return ReplyNotificationHandler(commentsRepository, currentPubkey);
}
