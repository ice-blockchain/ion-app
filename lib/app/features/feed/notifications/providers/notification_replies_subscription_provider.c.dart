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

part 'notification_replies_subscription_provider.c.g.dart';

// @riverpod
// Future<void> notificationRepliesSubscription(Ref ref) async {
//   final currentPubkey = ref.watch(currentPubkeySelectorProvider);
//   final commentsRepository = ref.watch(commentsRepositoryProvider);

//   if (currentPubkey == null) {
//     throw UserMasterPubkeyNotFoundException();
//   }

//   final requestFilter = RequestFilter(
//     kinds: const [ModifiablePostEntity.kind],
//     tags: {
//       '#p': [currentPubkey],
//     },
//     search: SearchExtensions([
//       TagMarkerSearchExtension(
//         tagName: RelatedReplaceableEvent.tagName,
//         marker: RelatedEventMarker.reply.toShortString(),
//       ),
//     ]).toString(),
//   );

//   final lastCreatedAt = await commentsRepository.lastCreatedAt(CommentIonNotificationType.reply);

//   final latestSyncedEventTimestamp = await ref.watch(eventSyncerServiceProvider).syncEvents(
//     requestFilters: [requestFilter],
//     sinceDateMicroseconds: lastCreatedAt?.microsecondsSinceEpoch,
//     saveCallback: (eventMessage) {
//       final parser = ref.read(eventParserProvider);
//       final entity = parser.parse(eventMessage);
//       if (entity.masterPubkey != currentPubkey) {
//         commentsRepository.save(entity);
//       }
//     },
//   );

//   final requestMessage = RequestMessage()
//     ..addFilter(requestFilter.copyWith(since: () => latestSyncedEventTimestamp));

//   final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

//   final subscription = entities
//       .where((entity) => entity.masterPubkey != currentPubkey)
//       .listen(commentsRepository.save);

//   ref.onDispose(subscription.cancel);
// }

// // SPDX-License-Identifier: ice License 1.0

// import 'dart:async';

// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ion/app/exceptions/exceptions.dart';
// import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
// import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
// import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
// import 'package:ion/app/features/ion_connect/ion_connect.dart';
// import 'package:ion/app/features/ion_connect/providers/ion_connect_persistent_subscription.c.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'notification_likes_event_handler.c.g.dart';

// class NotificationLikesEventHandler extends PersistentSubscriptionEventHandler {
//   NotificationLikesEventHandler(this.likesRepository, this.currentPubkey);

//   final LikesRepository likesRepository;
//   final String currentPubkey;

//   @override
//   bool canHandle(EventMessage eventMessage) {
//     return eventMessage.kind == ReactionEntity.kind;
//   }

//   @override
//   Future<void> handle(EventMessage eventMessage) async {
//     final entity = ReactionEntity.fromEventMessage(eventMessage);
//     final isOwnReaction = entity.masterPubkey == currentPubkey;
//     if (!isOwnReaction) {
//       await likesRepository.save(entity);
//     }
//   }
// }

// @riverpod
// Future<NotificationLikesEventHandler> notificationLikesEventHandler(Ref ref) async {
//   final likesRepository = ref.watch(likesRepositoryProvider);
//   final currentPubkey = ref.watch(currentPubkeySelectorProvider);

//   if (currentPubkey == null) {
//     throw UserMasterPubkeyNotFoundException();
//   }

//   return NotificationLikesEventHandler(likesRepository, currentPubkey);
// }

class NotificationRepliesEventHandler extends PersistentSubscriptionEventHandler {
  NotificationRepliesEventHandler(this.commentsRepository, this.currentPubkey);

  final CommentsRepository commentsRepository;
  final String currentPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    final entity = ModifiablePostEntity.fromEventMessage(eventMessage);
    final isOwnReply = entity.masterPubkey == currentPubkey;
    final isReply = entity.data.relatedEvents?.any(
          (event) => event.marker == RelatedEventMarker.reply && event is ReplaceableEventReference,
        ) ??
        false;
    return eventMessage.kind == ModifiablePostEntity.kind && isReply && !isOwnReply;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = ModifiablePostEntity.fromEventMessage(eventMessage);
    await commentsRepository.save(entity);
  }
}

@riverpod
NotificationRepliesEventHandler notificationRepliesEventHandler(Ref ref) {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return NotificationRepliesEventHandler(commentsRepository, currentPubkey);
}
