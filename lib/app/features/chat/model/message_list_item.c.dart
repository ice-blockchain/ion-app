// SPDX-License-Identifier: ice License 1.0

// // SPDX-License-Identifier: ice License 1.0

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:ion/app/features/chat/model/message_author.c.dart';
// import 'package:ion/app/features/chat/model/money_message_type.dart';

// part 'message_list_item.c.freezed.dart';

// abstract class MessageWithAuthor {
//   MessageAuthor get author;
// }

// /// Representation of any element in the chat list.
// @freezed
// sealed class MessageListItem with _$MessageListItem {
//   const factory MessageListItem.date({
//     required DateTime time,
//   }) = DateItem;

//   const factory MessageListItem.system({
//     required String text,
//     required DateTime time,
//   }) = SystemItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.text({
//     required MessageAuthor author,
//     required String text,
//     required DateTime time,
//     // RepliedMessage? repliedMessage,
//   }) = TextItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.photo({
//     required MessageAuthor author,
//     required DateTime time,
//     required String imageUrl,
//     String? text,
//   }) = PhotoItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.audio({
//     required MessageAuthor author,
//     required DateTime time,
//     required String audioId,
//     required String audioUrl,
//   }) = AudioItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.video({
//     required MessageAuthor author,
//     required DateTime time,
//     required String videoUrl,
//     String? text,
//   }) = VideoItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.document({
//     required String fileName,
//     required MessageAuthor author,
//     required DateTime time,
//   }) = DocumentItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.link({
//     required String link,
//     required MessageAuthor author,
//     required DateTime time,
//   }) = LinkItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.shareProfile({
//     required String displayName,
//     required MessageAuthor author,
//     required DateTime time,
//   }) = ShareProfileItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.poll({
//     required MessageAuthor author,
//     required DateTime time,
//   }) = PollItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.money({
//     required MoneyMessageType type,
//     required double amount,
//     required double usdt,
//     required String chain,
//     required MessageAuthor author,
//     required DateTime time,
//   }) = MoneyItem;

//   @Implements<MessageWithAuthor>()
//   const factory MessageListItem.emoji({
//     required String emoji,
//     required MessageAuthor author,
//     required DateTime time,
//   }) = EmojiItem;
// }
