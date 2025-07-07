// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'message_status_provider.r.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Stream<MessageDeliveryStatus> messageStatus(
  Ref ref,
  EventReference eventReference,
) async* {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    yield MessageDeliveryStatus.created;
    return;
  }

  final stream = ref.watch(conversationMessageDataDaoProvider).messageStatus(
        eventReference: eventReference,
        currentUserMasterPubkey: currentUserMasterPubkey,
      );

  await for (final status in stream) {
    yield status;
  }
}

@riverpod
Stream<MessageDeliveryStatus> sharedPostMessageStatus(
  Ref ref,
  ReplaceablePrivateDirectMessageEntity entity,
) async* {
  final eventReference = entity.toEventReference();
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    yield MessageDeliveryStatus.created;
    return;
  }

  final sharedEntityMessageDeliveryStatusStream =
      ref.watch(conversationMessageDataDaoProvider).messageStatus(
            eventReference: eventReference,
            currentUserMasterPubkey: currentUserMasterPubkey,
          );

  final quotedEventDeliveryStatusStream =
      ref.watch(conversationMessageDataDaoProvider).messageStatus(
            eventReference: entity.data.quotedEvent!.eventReference,
            currentUserMasterPubkey: currentUserMasterPubkey,
          );

  final storyReactionReference =
      await ref.read(conversationMessageReactionDaoProvider).storyReaction(eventReference);

  final storyReactionDeliveryStatusStream = storyReactionReference != null
      ? ref.watch(conversationMessageDataDaoProvider).messageStatus(
            eventReference: storyReactionReference,
            currentUserMasterPubkey: currentUserMasterPubkey,
          )
      : Stream.value(MessageDeliveryStatus.created);

  // Combine the latest values from each stream, emitting whenever any stream emits a new value.
  yield* sharedEntityMessageDeliveryStatusStream.combineLatestAll(
    [
      quotedEventDeliveryStatusStream,
      storyReactionDeliveryStatusStream,
    ],
  ).map((statuses) {
    if (statuses.contains(MessageDeliveryStatus.deleted)) {
      return MessageDeliveryStatus.deleted;
    } else if (statuses.contains(MessageDeliveryStatus.failed)) {
      return MessageDeliveryStatus.failed;
    } else {
      return MessageDeliveryStatus.sent;
    }
  });
}
