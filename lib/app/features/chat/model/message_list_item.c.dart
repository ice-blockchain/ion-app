// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/chat/model/replied_message.c.dart';

part 'message_list_item.c.freezed.dart';

abstract class ConversationMessage {
  String get id;
  MessageAuthor get author;
}

/// Representation of any element in the chat list.
@freezed
sealed class MessageListItem with _$MessageListItem {
  const factory MessageListItem.date({
    required String id,
    required DateTime time,
  }) = DateItem;

  const factory MessageListItem.system({
    required String id,
    required String text,
    required DateTime time,
  }) = SystemItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.text({
    required String id,
    required String text,
    required DateTime time,
    required MessageAuthor author,
    RepliedMessage? repliedMessage,
  }) = TextItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.photo({
    required String id,
    required MessageAuthor author,
    required DateTime time,
    required String imageUrl,
    String? text,
  }) = PhotoItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.audio({
    required String id,
    required MessageAuthor author,
    required DateTime time,
    required String audioId,
    required String audioUrl,
  }) = AudioItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.video({
    required String id,
    required MessageAuthor author,
    required DateTime time,
    required String videoUrl,
    String? text,
  }) = VideoItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.document({
    required String id,
    required String fileName,
    required MessageAuthor author,
    required DateTime time,
  }) = DocumentItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.link({
    required String id,
    required String link,
    required MessageAuthor author,
    required DateTime time,
  }) = LinkItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.shareProfile({
    required String id,
    required String displayName,
    required MessageAuthor author,
    required DateTime time,
  }) = ShareProfileItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.poll({
    required String id,
    required MessageAuthor author,
    required DateTime time,
  }) = PollItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.money({
    required String id,
    required MoneyMessageType type,
    required double amount,
    required double usdt,
    required String chain,
    required MessageAuthor author,
    required DateTime time,
  }) = MoneyItem;

  @Implements<ConversationMessage>()
  const factory MessageListItem.emoji({
    required String id,
    required String emoji,
    required MessageAuthor author,
    required DateTime time,
  }) = EmojiItem;
}
