// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';

part 'ee2e_conversation_data.c.freezed.dart';

@freezed
class Ee2eConversationEntity with _$Ee2eConversationEntity {
  const factory Ee2eConversationEntity({
    required String name,
    required ChatType type,
    required List<String> participants,
    int? imageWidgth,
    int? imageHeight,
    String? nickname,
    String? imageUrl,
    DateTime? lastMessageAt,
    String? lastMessageContent,
  }) = _PrivateDirectMessageEntity;

  const Ee2eConversationEntity._();
}
