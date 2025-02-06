// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';

part 'conversation_data.c.freezed.dart';

@freezed
class ConversationEntity with _$ConversationEntity {
  factory ConversationEntity({
    required String id,
    required String name,
    required ChatType type,
    required List<String> participantsMasterkeys,
    String? imageUrl,
    DateTime? lastMessageAt,
    @Default('') String nickname,
    @Default(false) bool isArchived,
    @Default(0) int unreadMessagesCount,
    @Default('') String lastMessageContent,
  }) = _ConversationEntity;

  const ConversationEntity._();
}
