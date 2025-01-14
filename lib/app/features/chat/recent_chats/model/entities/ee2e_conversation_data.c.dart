// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';

part 'ee2e_conversation_data.c.freezed.dart';

@freezed
class Ee2eConversationEntity with _$Ee2eConversationEntity {
  const factory Ee2eConversationEntity({
    required String name,
    required ChatType type,
    required DateTime lastMessageAt,
    required List<String> participants,
    required String lastMessageContent,
    String? nickname,
    String? imageUrl,
    String? imagePath,
  }) = _PrivateDirectMessageEntity;

  const Ee2eConversationEntity._();
}
