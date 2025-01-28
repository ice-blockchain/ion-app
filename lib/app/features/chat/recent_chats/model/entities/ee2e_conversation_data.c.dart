// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';

part 'ee2e_conversation_data.c.freezed.dart';

@freezed
class E2eeConversationEntity with _$E2eeConversationEntity {
  factory E2eeConversationEntity({
    required String name,
    required ChatType type,
    required List<String> participants,
    @Default(false) bool isArchived,
    int? imageWidth,
    int? imageHeight,
    String? id,
    String? nickname,
    String? imageUrl,
    DateTime? lastMessageAt,
    int? unreadMessagesCount,
    String? lastMessageContent,
  }) = _PrivateDirectMessageEntity;

  const E2eeConversationEntity._();
}
