// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_status_provider.c.g.dart';

@riverpod
//TODO: Make this provider alive till conversation page is opened
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

  await for (final statuses in StreamZip([
    sharedEntityMessageDeliveryStatusStream,
    quotedEventDeliveryStatusStream,
    storyReactionDeliveryStatusStream,
  ])) {
    if (statuses.contains(MessageDeliveryStatus.failed)) {
      yield MessageDeliveryStatus.failed;
    } else {
      yield MessageDeliveryStatus.sent;
    }
  }
}
