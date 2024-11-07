// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/chat_date_header_text/chat_date_header_text.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/audio_message/audio_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/emoji_message/emoji_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/money_message/money_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/photo_message/photo_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/poll_message/poll_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/profile_share_message/profile_share_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/text_message/text_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/url_preview_message/url_preview_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/video_message/video_message.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/model/money_message_type.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends ConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const MessagingHeader(),
              // const MessagingEmptyView(),
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
                              ),
                            ],
                          );
                        case 1:
                          return const TextMessage(
                            message: 'How are you doing?',
                            isMe: false,
                          );
                        case 2:
                          return const EmojiMessage(emoji: '😂', isMe: true);
                        case 3:
                          return const EmojiMessage(emoji: '🤔', isMe: false);
                        case 4:
                          return const PhotoMessage(
                            isMe: true,
                            imageUrl: 'https://picsum.photos/700/900',
                            message: 'Check this out!',
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
                          );
                        case 8:
                          return const AudioMessage(
                            '112133',
                            audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
                            isMe: false,
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
                          );
                        case 12:
                          return const ProfileShareMessage(
                            isMe: true,
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
