// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_messages_provider.c.g.dart';

@riverpod
Stream<List<EventMessage>> conversationMessages(
  Ref ref,
  String conversationId,
  ConversationType type,
) async* {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    yield [];
    return;
  }

  final stream = ref.watch(conversationMessageDaoProvider).getMessages(
        conversationId: conversationId,
        currentUserMasterPubkey: currentUserMasterPubkey,
      );

  yield* stream;
}
