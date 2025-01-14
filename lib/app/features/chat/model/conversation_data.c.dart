// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

part 'conversation_data.c.freezed.dart';

@freezed
class ConversationData with _$ConversationData {
  const factory ConversationData({
    required String name,
    required ChatType type,
    required List<String> members,
    String? nickname,
    String? imageUrl,
    MediaFile? mediaImage,
  }) = _ConversationData;
}
