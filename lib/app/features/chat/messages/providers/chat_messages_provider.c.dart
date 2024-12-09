// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/chat/model/replied_message.c.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_provider.c.g.dart';

/// Mocked provider that simulates receiving and mapping data messages
/// from the server to a model, which describes to UI what should be displayed.
@riverpod
List<MessageListItem> chatMessages(Ref ref) {
  final mockedDate = DateTime.now();
  const mockedMessageAuthor = MessageAuthor(
    name: 'Test',
    imageUrl: 'https://picsum.photos/500/400',
  );
  const mockedCurrentAuthor = MessageAuthor(
    name: 'Test',
    imageUrl: 'https://picsum.photos/500/400',
    isCurrentUser: true,
  );

  return [
    MessageListItem.date(time: mockedDate),
    MessageListItem.text(
      text: 'Hello there!',
      author: mockedMessageAuthor,
      time: mockedDate,
    ),
    MessageListItem.text(
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      author: mockedMessageAuthor,
      time: mockedDate,
      repliedMessage: RepliedMessage(
        author: mockedCurrentAuthor,
        message: TextRecentChatMessage('Hello there!', mockedDate),
      ),
    ),
    MessageListItem.emoji(
      emoji: '😂',
      author: mockedCurrentAuthor,
      time: mockedDate,
      // reactions: mockReactionsSimple,
    ),
    MessageListItem.emoji(
      emoji: '🤔',
      author: mockedMessageAuthor,
      time: mockedDate,
      // reactions: mockReactionsSimple,
    ),
    MessageListItem.photo(
      author: mockedMessageAuthor,
      time: mockedDate,
      text: 'Check this out!',
      imageUrl: 'https://picsum.photos/700/900',
    ),
    MessageListItem.photo(
      author: mockedCurrentAuthor,
      time: mockedDate,
      text: 'Hey there! Can you check this, please and tell me what you think?',
      imageUrl: 'https://picsum.photos/500/400',
    ),
    MessageListItem.video(
      author: mockedCurrentAuthor,
      time: mockedDate,
      text: 'Look at this video',
      videoUrl: 'https://videos.pexels.com/video-files/4002110/4002110-sd_640_360_25fps.mp4',
    ),
    MessageListItem.video(
      author: mockedMessageAuthor,
      time: mockedDate,
      videoUrl: 'https://videos.pexels.com/video-files/5975407/5975407-hd_1080_1920_30fps.mp4',
    ),
    MessageListItem.audio(
      author: mockedMessageAuthor,
      time: mockedDate,
      audioId: '112133',
      audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
    ),
    MessageListItem.audio(
      author: mockedCurrentAuthor,
      time: mockedDate,
      audioId: '111333',
      audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
    ),
    MessageListItem.link(
      link: 'https://www.ice.io/',
      time: mockedDate,
      author: mockedCurrentAuthor,
    ),
    MessageListItem.link(
      link: 'https://www.ice.io/',
      time: mockedDate,
      author: mockedMessageAuthor,
    ),
    MessageListItem.shareProfile(
      time: mockedDate,
      author: mockedCurrentAuthor,
      displayName: 'Test',
    ),
    MessageListItem.shareProfile(
      time: mockedDate,
      author: mockedMessageAuthor,
      displayName: 'Test',
    ),
    MessageListItem.poll(
      time: mockedDate,
      author: mockedMessageAuthor,
    ),
    MessageListItem.poll(
      time: mockedDate,
      author: mockedCurrentAuthor,
    ),
    MessageListItem.money(
      type: MoneyMessageType.receive,
      amount: 100,
      usdt: 12,
      chain: 'Ice Open Network',
      author: mockedCurrentAuthor,
      time: mockedDate,
    ),
    MessageListItem.money(
      type: MoneyMessageType.receive,
      amount: 1450,
      usdt: 120,
      chain: 'ETH',
      author: mockedMessageAuthor,
      time: mockedDate,
    ),
    MessageListItem.money(
      type: MoneyMessageType.request,
      amount: 4333,
      usdt: 120,
      chain: 'VET',
      author: mockedCurrentAuthor,
      time: mockedDate,
    ),
    MessageListItem.money(
      type: MoneyMessageType.request,
      amount: 100,
      usdt: 12,
      chain: 'BTC',
      author: mockedMessageAuthor,
      time: mockedDate,
    ),
    MessageListItem.text(
      text: 'Hello there!',
      author: mockedCurrentAuthor,
      time: mockedDate,
    ),
  ];
}
