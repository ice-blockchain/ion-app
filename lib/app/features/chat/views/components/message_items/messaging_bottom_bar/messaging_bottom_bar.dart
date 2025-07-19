// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/providers/draft_message_provider.r.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.r.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_edit_message_provider.r.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/text_message_limit_label.dart';
import 'package:ion/app/features/feed/stories/hooks/use_keyboard_height.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_user_provider.r.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.r.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/compressors/audio_compressor.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingBottomBar extends HookConsumerWidget {
  const MessagingBottomBar({
    required this.onSubmitted,
    required this.conversationId,
    required this.receiverMasterPubkey,
    super.key,
  });

  final Future<void> Function({String? content, List<MediaFile>? mediaFiles}) onSubmitted;
  final String? conversationId;
  final String receiverMasterPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    final controller = useTextEditingController();
    final textControllerFocusNode = useFocusNode();
    final recordedMediaFile = useState<MediaFile?>(null);
    final recorderController = useRef(RecorderController());
    final isTextLimitReached = useState<bool>(false);

    final orgKeyboardHeight = useKeyboardHeight();
    final keyboardHeight =
        max(orgKeyboardHeight - MediaQuery.of(context).viewPadding.bottom, 0).toDouble();
    final isPreviousMore = ref.watch(isPreviousMoreProvider);

    final isBlocked =
        ref.watch(isBlockedNotifierProvider(receiverMasterPubkey)).valueOrNull ?? true;

    ref.listen(selectedEditMessageProvider, (_, selectedMessage) {
      if (selectedMessage != null) {
        controller.text = selectedMessage.contentDescription;
      } else {
        controller.clear();
      }
    });

    final double calculatedPadding = useMemoized(
      () {
        if (bottomBarState.isMore) {
          return 0;
        }

        if (isPreviousMore) {
          return isPreviousMore ? max(keyboardHeight, moreContentHeight) : keyboardHeight;
        }

        return keyboardHeight;
      },
      [bottomBarState, moreContentHeight, keyboardHeight],
    );

    useOnInit(
      () {
        if (conversationId != null) {
          final draftMessage = ref.read(draftMessageProvider(conversationId!));
          if (draftMessage != null && draftMessage.isNotEmpty) {
            controller.text = draftMessage;
            ref.read(messagingBottomBarActiveStateProvider.notifier).setHasText();
          }
        }
      },
      [conversationId],
    );

    useEffect(
      () {
        void onTextChanged() {
          if (conversationId != null) {
            ref.read(draftMessageProvider(conversationId!).notifier).draftMessage = controller.text;
          }
          isTextLimitReached.value =
              controller.text.length > ReplaceablePrivateDirectMessageData.textMessageLimit;
        }

        controller.addListener(onTextChanged);

        return () {
          controller.removeListener(onTextChanged);
        };
      },
      [controller, conversationId],
    );

    if (isBlocked) {
      return SizedBox(
        height: 45.0.s,
        child: TextButton(
          onPressed: () {
            ref.read(toggleBlockNotifierProvider.notifier).toggle(receiverMasterPubkey);
          },
          style: TextButton.styleFrom(
            minimumSize: Size(0, 40.0.s),
            padding: EdgeInsetsDirectional.only(start: 8.0.s),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.iconProfileBlockUser.icon(color: context.theme.appColors.primaryAccent),
              SizedBox(width: 6.0.s),
              Text(
                context.i18n.button_unblock,
                style: context.theme.appTextThemes.subtitle3
                    .copyWith(color: context.theme.appColors.primaryAccent),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        bottom: calculatedPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AbsorbPointer(
            absorbing: bottomBarState.isVoice,
            child: BottomBarInitialView(
              receiverPubKey: receiverMasterPubkey,
              controller: controller,
              textControllerFocusNode: textControllerFocusNode,
              onSubmitted: ({content, mediaFiles}) async {
                unawaited(onSubmitted(content: content, mediaFiles: mediaFiles));
                if (controller.text.isNotEmpty) {
                  ref.read(messagingBottomBarActiveStateProvider.notifier).setHasText();
                }
              },
            ),
          ),
          if (bottomBarState.isVoice ||
              bottomBarState.isVoiceLocked ||
              bottomBarState.isVoicePaused)
            BottomBarRecordingView(
              onRecordingFinished: (mediaFile) async {
                if (recordedMediaFile.value == null) {
                  recordedMediaFile.value = mediaFile;
                } else {
                  recordedMediaFile.value =
                      await ref.read(audioCompressorProvider).combineAudioFiles([
                    recordedMediaFile.value!,
                    mediaFile,
                  ]);
                }
                return recordedMediaFile.value!.path;
              },
              onCancelled: () {
                ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                recordedMediaFile.value = null;
              },
              recorderController: recorderController.value,
            ),
          TextMessageLimitLabel(textEditingController: controller),
          ActionButton(
            controller: controller,
            recorderController: recorderController.value,
            onSubmitted: isTextLimitReached.value
                ? null
                : () async {
                    if (recordedMediaFile.value != null) {
                      unawaited(
                        onSubmitted(
                          content: controller.text,
                          mediaFiles: [recordedMediaFile.value!],
                        ),
                      );
                    } else {
                      unawaited(onSubmitted(content: controller.text));
                    }
                    controller.clear();
                    recordedMediaFile.value = null;
                  },
          ),
        ],
      ),
    );
  }
}
