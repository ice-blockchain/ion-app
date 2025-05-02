// SPDX-License-Identifier: ice License 1.0

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_edit_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/text_message_limit_label.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class MessagingBottomBar extends HookConsumerWidget {
  const MessagingBottomBar({required this.onSubmitted, super.key});

  final Future<void> Function({String? content, List<MediaFile>? mediaFiles}) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    final controller = useTextEditingController();
    final recordedMediaFile = useState<MediaFile?>(null);
    final recorderController = useRef(RecorderController());
    final isTextLimitReached = useState<bool>(false);

    ref.listen(selectedEditMessageProvider, (_, selectedMessage) {
      if (selectedMessage != null) {
        controller.text = selectedMessage.contentDescription;
      } else {
        controller.clear();
      }
    });

    useEffect(
      () {
        void onTextChanged() {
          isTextLimitReached.value =
              controller.text.length > ReplaceablePrivateDirectMessageData.textMessageLimit;
        }

        controller.addListener(onTextChanged);

        return () {
          controller.removeListener(onTextChanged);
        };
      },
      [controller],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: bottomBarState.isVoice,
          child: BottomBarInitialView(controller: controller, onSubmitted: onSubmitted),
        ),
        if (bottomBarState.isVoice || bottomBarState.isVoiceLocked || bottomBarState.isVoicePaused)
          BottomBarRecordingView(
            onRecordingFinished: (mediaFile) {
              recordedMediaFile.value = mediaFile;
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
                    await onSubmitted(
                      content: controller.text,
                      mediaFiles: [recordedMediaFile.value!],
                    );
                  } else {
                    await onSubmitted(content: controller.text);
                  }
                  recordedMediaFile.value = null;
                },
        ),
      ],
    );
  }
}
