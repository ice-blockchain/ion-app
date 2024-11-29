// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = useMemoized(() => Random().nextBool(), []);

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
                  child: ColoredBox(
                    color: context.theme.appColors.primaryBackground,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return const Column(
                              children: [
                                ChatDateHeaderText(),
                                TextMessage(
                                  message: 'Hello there!',
                                  isMe: true,
                                  reactions: mockReactionsSimple,
                                ),
                              ],
                            );
                          case 1:
                            return const TextMessage(
                              message:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                              isMe: false,
                              reactions: mockReactionsMany,
                            );
                          case 2:
                            return const EmojiMessage(
                              emoji: '😂',
                              isMe: true,
                              reactions: mockReactionsSimple,
                              hasForwardedMessage: true,
                            );
                          case 3:
                            return const EmojiMessage(
                              emoji: '🤔',
                              hasForwardedMessage: true,
                              isMe: false,
                            );
                          case 4:
                            return const PhotoMessage(
                              isMe: true,
                              imageUrl: 'https://picsum.photos/700/900',
                              message: 'Check this out!',
                              reactions: mockReactionsMany,
                            );
                          case 5:
                            return const PhotoMessage(
                              message:
                                  'Hey there! Can you check this, please and tell me what you think?',
                              isMe: false,
                              imageUrl: 'https://picsum.photos/500/400',
                            );
                          case 6:
                            return const VideoMessage(
                              isMe: true,
                              message: 'Look at this video',
                              videoUrl:
                                  'https://videos.pexels.com/video-files/4002110/4002110-sd_640_360_25fps.mp4',
                            );
                          case 7:
                            return const VideoMessage(
                              isMe: false,
                              videoUrl:
                                  'https://videos.pexels.com/video-files/5975407/5975407-hd_1080_1920_30fps.mp4',
                              reactions: mockReactionsMany,
                            );
                          case 8:
                            return const AudioMessage(
                              '112133',
                              audioUrl: 'https://getsamplefiles.com/download/opus/sample-3.opus',
                              isMe: false,
                              reactions: mockReactionsMany,
                            );
                          case 9:
                            return const AudioMessage(
                              '111333',
                              audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
                              isMe: true,
                            );
                          case 10:
                            return const UrlPreviewMessage(isMe: true, url: 'https://www.ice.io/');
                          case 11:
                            return const UrlPreviewMessage(
                              isMe: false,
                              url: 'https://www.ice.io/',
                              reactions: mockReactionsMany,
                            );
                          case 12:
                            return const ProfileShareMessage(
                              isMe: true,
                              reactions: mockReactionsSimple,
                            );
                          case 13:
                            return const ProfileShareMessage(
                              isMe: false,
                            );
                          case 14:
                            return const PollMessage(
                              isMe: false,
                            );
                          case 15:
                            return const PollMessage(
                              isMe: true,
                              reactions: mockReactionsMany,
                            );
                          case 16:
                            return const MoneyMessage(
                              type: MoneyMessageType.receive,
                              isMe: true,
                              amount: 100,
                              equivalentUsd: 12,
                              chain: 'Ice Open Network',
                            );
                          case 17:
                            return const MoneyMessage(
                              type: MoneyMessageType.receive,
                              isMe: false,
                              amount: 1450,
                              equivalentUsd: 120,
                              chain: 'ETH',
                              reactions: mockReactionsMany,
                            );
                          case 18:
                            return const MoneyMessage(
                              isMe: true,
                              type: MoneyMessageType.request,
                              amount: 4333,
                              equivalentUsd: 120,
                              chain: 'VET',
                            );
                          case 19:
                            return const MoneyMessage(
                              isMe: false,
                              type: MoneyMessageType.request,
                              amount: 100,
                              equivalentUsd: 12,
                              chain: 'BTC',
                            );
                          default:
                            return const TextMessage(
                              message: 'Hello there!',
                              isMe: true,
                              reactions: [],
                            );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8.0.s);
                      },
                      itemCount: 20,
                    ),
                  ),
                ),
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
