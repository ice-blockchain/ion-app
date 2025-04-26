// SPDX-License-Identifier: ice License 1.0

// // SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'message_list_item.c.freezed.dart';

abstract class MessageInfo {
  EventMessage get eventMessage;
  String get contentDescription;
}

/// Representation of any element in the chat list.
@freezed
sealed class ChatMessageInfoItem with _$ChatMessageInfoItem {
  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.text({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = TextItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.emoji({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = EmojiItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.audio({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = AudioItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.media({
    required EventMessage eventMessage,
    required String contentDescription,
    required List<MessageMediaTableData> medias,
  }) = MediaItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.storyReply({
    required EventMessage eventMessage,
    required String contentDescription,
    required List<MessageMediaTableData> medias,
  }) = StoryReplyItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.document({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = DocumentItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.shareProfile({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = ShareProfileItem;

  @Implements<MessageInfo>()
  const factory ChatMessageInfoItem.money({
    required EventMessage eventMessage,
    required String contentDescription,
  }) = MoneyItem;
}
