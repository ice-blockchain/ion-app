// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_message_load_media_provider.c.dart';
import 'package:ion/app/features/chat/hooks/use_audio_playback_controller.dart';
import 'package:ion/app/features/chat/hooks/use_has_reaction.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/replied_message_list_item_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/reply_message/reply_message.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/audio_wave_playback_service/audio_wave_playback_service.c.dart';
import 'package:ion/app/services/compressors/audio_compressor.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'components/audio_wave_form_display.dart';
part 'components/play_pause_button.dart';

class AudioMessage extends HookConsumerWidget {
  const AudioMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    final audioUrl = useState<String?>(null);

    final hasReactions = useHasReaction(eventMessage, ref);

    final messageMedia =
        ref.watch(chatMediasProvider(eventMessageId: eventMessage.id)).valueOrNull?.firstOrNull;

    final mediaAttachment =
        messageMedia?.remoteUrl == null ? null : entity.data.media[messageMedia?.remoteUrl!];

    useEffect(
      () {
        if (mediaAttachment?.url == null) return null;
        ref
            .read(
          chatMessageLoadMediaProvider(
            entity: entity,
            mediaAttachment: mediaAttachment,
            loadThumbnail: false,
          ),
        )
            .then((value) {
          if (value != null) {
            ref.read(audioCompressorProvider).compressAudioToWav(value.path).then((value) {
              audioUrl.value = value;
            });
          }
        });
        return null;
      },
      [messageMedia?.cacheKey, mediaAttachment?.url],
    );

    useEffect(
      () {
        ref
            .read(
          chatMessageLoadMediaProvider(
            entity: entity,
            mediaAttachment: mediaAttachment,
            cacheKey: messageMedia?.cacheKey,
          ),
        )
            .then((value) {
          if (context.mounted) {
            audioUrl.value = value?.path;
          }
        });
        return null;
      },
      [mediaAttachment?.thumb, messageMedia?.cacheKey],
    );

    final audioPlaybackState = useState<PlayerState?>(null);
    final audioPlaybackController = useAudioWavePlaybackController();

    final playerWaveStyle = useMemoized(
      () => PlayerWaveStyle(
        liveWaveColor:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
        fixedWaveColor: context.theme.appColors.sheetLine,
        seekLineColor: Colors.transparent,
        waveThickness: 1.0.s,
        spacing: 2.0.s,
      ),
      [isMe],
    );

    useEffect(
      () {
        if (audioUrl.value == null) return null;
        ref.read(audioWavePlaybackServiceProvider).initializePlayer(
              eventMessage.id,
              audioUrl.value!,
              audioPlaybackController,
              playerWaveStyle,
            );

        // Listen to player state changes
        audioPlaybackController.onPlayerStateChanged.listen((event) {
          if (event != PlayerState.stopped) {
            audioPlaybackState.value = event;
          }
        });

        return null;
      },
      [audioUrl.value],
    );

    final metadataWidth = useState<double>(0);
    final metadataKey = useMemoized(GlobalKey.new);
    final contentPadding = EdgeInsets.all(12.0.s);

    useOnInit(() {
      final renderBox = metadataKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        metadataWidth.value = renderBox.size.width;
      }
    });

    final messageItem = AudioItem(
      eventMessage: eventMessage,
      contentDescription: context.i18n.common_voice_message,
    );

    final repliedEventMessage = ref.watch(repliedMessageListItemProvider(messageItem));

    final repliedMessageItem = getRepliedMessageListItem(
      ref: ref,
      repliedEventMessage: repliedEventMessage.valueOrNull,
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: AudioItem(
        eventMessage: eventMessage,
        contentDescription: context.i18n.common_voice_message,
      ),
      contentPadding: contentPadding,
      child: VisibilityDetector(
        key: ValueKey(audioUrl),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            audioPlaybackController.pausePlayer();
          }
        },
        child: Column(
          children: [
            if (repliedMessageItem != null) ReplyMessage(messageItem, repliedMessageItem),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _PlayPauseButton(
                            audioPlaybackController: audioPlaybackController,
                            audioPlaybackState: audioPlaybackState,
                          ),
                          SizedBox(width: 8.0.s),
                          _AudioWaveformDisplay(
                            audioPlaybackController: audioPlaybackController,
                            audioPlaybackState: audioPlaybackState,
                            playerWaveStyle: playerWaveStyle,
                            isMe: isMe,
                          ),
                        ],
                      ),
                      MessageReactions(
                        isMe: isMe,
                        eventMessage: eventMessage,
                      ),
                    ],
                  ),
                ),
                MessageMetaData(
                  eventMessage: eventMessage,
                  startPadding: hasReactions ? 0.0.s : 8.0.s,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
