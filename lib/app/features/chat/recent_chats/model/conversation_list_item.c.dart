// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'conversation_list_item.c.freezed.dart';

@freezed
class ConversationListItem with _$ConversationListItem {
  const factory ConversationListItem({
    required String conversationId,
    required ConversationType type,
    required int joinedAt,
    required bool isArchived,
    EventMessage? latestMessage,
  }) = _ConversationListItem;
}

extension ConversationListItemX on ConversationListItem {
  String receiverMasterPubkey(String? currentUserMasterPubkey) {
    return latestMessage!.participantsMasterPubkeys.singleWhere(
      (masterPubkey) => masterPubkey != currentUserMasterPubkey,
    );
  }
}
