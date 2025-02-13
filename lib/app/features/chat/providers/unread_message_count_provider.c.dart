// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_message_count_provider.c.g.dart';

@riverpod
Stream<int> getUnreadMessagesCount(Ref ref, String conversationId) async* {
  final currentUserMasterPubkey = await ref.watch(currentPubkeySelectorProvider.future);

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }
  yield* ref
      .watch(conversationMessageDaoProvider)
      .getUnreadMessagesCount(currentUserMasterPubkey, conversationId);
}
