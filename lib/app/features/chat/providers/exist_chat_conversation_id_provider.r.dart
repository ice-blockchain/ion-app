// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exist_chat_conversation_id_provider.r.g.dart';

@riverpod
Future<String?> existChatConversationId(Ref ref, List<String> participantsMasterPubkeys) async {
  final sortedMasterPubkeys = List<String>.from(participantsMasterPubkeys)..sort();
  return ref
      .watch(conversationDaoProvider)
      .getExistOneToOneConversationId(sortedMasterPubkeys);
}
