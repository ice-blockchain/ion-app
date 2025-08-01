// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_notification_handler.r.g.dart';

class ReplyNotificationHandler extends GlobalSubscriptionEventHandler {
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
ReplyNotificationHandler? replyNotificationHandler(Ref ref) {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    return null;
  }

  return ReplyNotificationHandler(commentsRepository, currentPubkey);
}
