// SPDX-License-Identifier: ice License 1.0
//TODO: use it when we list all group messages

// import 'package:ion/app/features/chat/model/message_author.f.dart';
// import 'package:ion/app/features/chat/model/message_list_item.f.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'author_to_display_provider.r.g.dart';

// @riverpod
// class AuthorsToDisplayProvider extends _$AuthorsToDisplayProvider {
//   @override
//   FutureOr<void> build(List<MessageListItem> messages) {
//     this.messages = messages;
//   }

//   bool isMessageFromDifferentUser(int index, MessageAuthor? currentAuthor) {
//     if (index < 0 || index >= messages.length) return true;

//     final message = messages[index];
//     if (message case final MessageWithAuthor messageWithAuthor) {
//       return currentAuthor != messageWithAuthor.author;
//     }
//     return true;
//   }

//   MessageAuthor? getAuthorToDisplay(int index) {
//     if (index < 0 || index >= messages.length) return null;

//     final message = messages[index];
//     if (message is! MessageWithAuthor) return null;

//     final currentAuthor = (message as MessageWithAuthor).author;
//     final isFirstMessageFromSender =
//         index == 0 || isMessageFromDifferentUser(index - 1, currentAuthor);

//     return isFirstMessageFromSender ? currentAuthor : null;
//   }
// }
