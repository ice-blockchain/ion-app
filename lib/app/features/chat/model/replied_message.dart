// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/providers/mock.dart';

part 'replied_message.freezed.dart';

@freezed
class RepliedMessage with _$RepliedMessage {
  const factory RepliedMessage({
    required MessageAuthor author,
    required RecentChatMessage message,
  }) = _RepliedMessage;
}
