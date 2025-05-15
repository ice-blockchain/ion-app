// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_status_provider.c.g.dart';

@Riverpod(keepAlive: true)
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
