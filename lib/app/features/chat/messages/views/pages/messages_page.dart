// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/model/message_list_item.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = useMemoized(() => Random().nextBool(), []);
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

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                imageUrl: 'https://i.pravatar.cc/150?u=@anna',
                isVerified: true,
                name: 'Selena Maringue',
                subtitle: Text(
                  '@selenamaringue',
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              if (isEmpty)
                MessagingEmptyView(
                  title: context.i18n.messaging_empty_description,
                  asset: Assets.svg.walletChatEmptystate,
                  trailing: GestureDetector(
                    onTap: () {
                      ChatLearnMoreModalRoute().push<void>(context);
                    },
                    child: Text(
                      context.i18n.button_learn_more,
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ChatMessagesList([
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

                      // reactions: mockReactionsMany,
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
                      videoUrl:
                          'https://videos.pexels.com/video-files/4002110/4002110-sd_640_360_25fps.mp4',
                    ),
                    MessageListItem.video(
                      author: mockedMessageAuthor,
                      time: mockedDate,
                      videoUrl:
                          'https://videos.pexels.com/video-files/5975407/5975407-hd_1080_1920_30fps.mp4',
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
                  ]),
                ),
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
