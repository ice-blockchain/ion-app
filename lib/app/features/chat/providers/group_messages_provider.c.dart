// // SPDX-License-Identifier: ice License 1.0

// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:ion/app/features/chat/model/message_author.c.dart';
// import 'package:ion/app/features/chat/model/message_list_item.c.dart';
// import 'package:ion/app/features/chat/model/money_message_type.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'group_messages_provider.c.g.dart';

// /// Mocked provider that simulates receiving and mapping data messages
// /// from the server to a model, which describes to UI what should be displayed.
// @riverpod
// List<MessageListItem> groupMessages(Ref ref) {
//   const currentAuthor = MessageAuthor(
//     name: 'Current',
//     imageUrl: 'https://picsum.photos/200/300',
//     isCurrentUser: true,
//   );
//   const samantaAuthor = MessageAuthor(
//     name: 'Samanta Gabriella',
//     imageUrl: 'https://picsum.photos/200/300',
//   );
//   const danielAuthor = MessageAuthor(
//     name: 'Daniel Timrock',
//     imageUrl: 'https://picsum.photos/200/300',
//   );

//   final date = DateTime.now();

//   return [
//     MessageListItem.date(time: date),
//     MessageListItem.system(text: 'The group has been created', time: date),
//     MessageListItem.text(author: samantaAuthor, text: 'Hi there!', time: date),
//     MessageListItem.text(author: danielAuthor, text: 'Hello world!', time: date),
//     MessageListItem.emoji(author: danielAuthor, emoji: '😊', time: date),
//     MessageListItem.text(author: danielAuthor, text: 'How it’s going?', time: date),
//     MessageListItem.text(
//       author: samantaAuthor,
//       text: 'Hello there! How are you?',
//       time: date,
//     ),
//     MessageListItem.text(author: danielAuthor, text: 'How’s Max doing ?', time: date),
//     MessageListItem.text(
//       author: currentAuthor,
//       text: 'Hi folks, perfect, I’ve got hot ice!',
//       time: date,
//     ),
//     MessageListItem.text(
//       author: currentAuthor,
//       text:
//           'What is your forecast regarding the price of the main cryptocurrency this month? Share it in the comments',
//       time: date,
//     ),
//     MessageListItem.photo(
//       author: danielAuthor,
//       time: date,
//       imageUrl: 'https://picsum.photos/700/900',
//     ),
//     MessageListItem.audio(
//       author: samantaAuthor,
//       time: date,
//       audioId: '112133',
//       audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
//     ),
//     MessageListItem.video(
//       author: danielAuthor,
//       time: date,
//       videoUrl: 'https://videos.pexels.com/video-files/5975407/5975407-hd_1080_1920_30fps.mp4',
//     ),
//     MessageListItem.link(author: samantaAuthor, time: date, link: 'https://videos.pexels.com'),
//     MessageListItem.shareProfile(author: danielAuthor, time: date, displayName: 'Some profile'),
//     MessageListItem.poll(author: samantaAuthor, time: date),
//     MessageListItem.money(
//       author: danielAuthor,
//       time: date,
//       type: MoneyMessageType.request,
//       amount: 100,
//       usdt: 100000,
//       chain: 'BTC',
//     ),
//     MessageListItem.money(
//       author: samantaAuthor,
//       time: date,
//       type: MoneyMessageType.receive,
//       amount: 100,
//       usdt: 100000,
//       chain: 'BTC',
//     ),
//     MessageListItem.emoji(
//       author: danielAuthor,
//       time: date,
//       emoji: '😁',
//     ),
//   ];
// }
