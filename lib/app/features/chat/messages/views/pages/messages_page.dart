// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/audio_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/emoji_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/money_receive_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/money_request_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/photo_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/pool_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/profile_share_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/simple_text_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/url_message.dart';
import 'package:ion/app/features/chat/messages/views/components/message_types/video_message.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/messages/views/components/messaging_header/messaging_header.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 24.0.s : 8.0.s,
          ),
          bottom: false,
          child: Column(
            children: [
              const MessagingHeader(),
              Expanded(
                child: ColoredBox(
                  color: context.theme.appColors.primaryBackground,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.0.s,
                                  vertical: 1.0.s,
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: 12.0.s,
                                ),
                                decoration: BoxDecoration(
                                  color: context.theme.appColors.secondaryBackground,
                                  borderRadius: BorderRadius.circular(16.0.s),
                                ),
                                child: Text(
                                  '8 October',
                                  style: context.theme.appTextThemes.caption3.copyWith(
                                    color: context.theme.appColors.onTertararyBackground,
                                  ),
                                ),
                              ),
                              const SimpleTextMessage(
                                message: 'Hello there!',
                                isMe: true,
                              ),
                            ],
                          );
                        case 1:
                          return const SimpleTextMessage(
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
                            imageUrl: 'https://picsum.photos/500/300',
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
                            '1121',
                            audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
                            isMe: false,
                          );
                        case 9:
                          return const AudioMessage(
                            '111',
                            audioUrl: 'https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav',
                            isMe: true,
                          );
                        case 10:
                          return const UrlMessage(isMe: true, url: 'https://www.ice.io/');
                        case 11:
                          return const UrlMessage(isMe: false, url: 'https://www.google.com/');
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
                          return const MoneyReceiveMessage(
                            isMe: true,
                          );
                        case 17:
                          return const MoneyReceiveMessage(
                            isMe: false,
                          );
                        case 18:
                          return const MoneyRequestMessage(isMe: true);
                        case 19:
                          return const MoneyRequestMessage(isMe: false);
                        default:
                          return const SimpleTextMessage(
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
