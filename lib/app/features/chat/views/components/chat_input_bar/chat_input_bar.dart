import 'dart:async';
import 'dart:math' show max;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/providers/attach_menu_shown_notifier.r.dart';
import 'package:ion/app/features/chat/providers/draft_message_provider.r.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.r.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_edit_message_provider.r.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_reply_message_provider.r.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/chat_attach_menu.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/chat_input_bar_recording_overlay.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/action_button.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/chat_attachment_menu_switch_button.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/chat_input_bar_camera_button.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/chat_text_field.dart';
import 'package:ion/app/features/chat/views/components/chat_input_bar/components/text_message_limit_label.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/compressors/audio_compressor.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';

const nenuHeight = 264.0;

class ChatInputBar extends HookConsumerWidget {
  const ChatInputBar({
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
    final textFieldFocusNode = useFocusNode();
    final textFieldController = useTextEditingController();
    final voiceRecorderController = useRef(RecorderController());

    final isAttachMenuShown = ref.watch(attachMenuShownProvider);
    final editMessage = ref.watch(selectedEditMessageProvider);
    final repliedMessage = ref.watch(selectedReplyMessageProvider);

    final isTogglingBottomView = useRef(false);
    final recordedMediaFile = useState<MediaFile?>(null);
    final isTextLimitReached = useState<bool>(false);
    final isKeyboardVisible = useState(false);
    final cachePadding = useState<double>(0);

    useOnInit(
      () {
        if (conversationId != null) {
          final draftMessage = ref.read(draftMessageProvider(conversationId!));
          if (draftMessage != null && draftMessage.isNotEmpty) {
            textFieldController.text = draftMessage;
          }
        }
      },
      [conversationId],
    );

    useEffect(
      () {
        void onTextChanged() {
          if (conversationId != null) {
            ref.read(draftMessageProvider(conversationId!).notifier).draftMessage =
                textFieldController.text;
          }
          isTextLimitReached.value = textFieldController.text.length >
              ReplaceablePrivateDirectMessageData.textMessageLimit;
        }

        textFieldController.addListener(onTextChanged);

        return () {
          textFieldController.removeListener(onTextChanged);
        };
      },
      [textFieldController, conversationId],
    );

    useEffect(
      () {
        if (editMessage != null || repliedMessage != null) {
          textFieldFocusNode.requestFocus();
        }
        return null;
      },
      [editMessage, repliedMessage],
    );

    useEffect(
      () {
        final keyboardVisibilitySubscription =
            KeyboardVisibilityController().onChange.listen((visible) {
          isKeyboardVisible.value = visible;
        });
        return keyboardVisibilitySubscription.cancel;
      },
      [],
    );

    useEffect(
      () {
        void textFieldFocusListener() {
          if (isTogglingBottomView.value) return;

          if (textFieldFocusNode.hasFocus) {
            if (isAttachMenuShown) {
              ref.read(attachMenuShownProvider.notifier).hide();
            }
          } else {
            if (isKeyboardVisible.value) {
              cachePadding.value = 0;
              ref.read(attachMenuShownProvider.notifier).hide();
            }
          }
        }

        textFieldFocusNode.addListener(textFieldFocusListener);
        return () => textFieldFocusNode.removeListener(textFieldFocusListener);
      },
      [textFieldFocusNode, isAttachMenuShown, isKeyboardVisible.value, isTogglingBottomView],
    );

    final double bottomPadding = max(
      MediaQuery.viewInsetsOf(context).bottom - MediaQuery.viewPaddingOf(context).bottom,
      0,
    );

    final bottomViewInset = (cachePadding.value > 0
        ? cachePadding.value
        : bottomPadding > 0
            ? bottomPadding
            : isAttachMenuShown
                ? ChatAttachMenu.moreContentHeight.s
                : 0.0);

    final showAttachMenu = useCallback(
      () {
        if (isAttachMenuShown) return;

        textFieldFocusNode.unfocus();
        cachePadding.value = bottomPadding;
        ref.read(attachMenuShownProvider.notifier).show();
      },
      [isAttachMenuShown, textFieldFocusNode, bottomPadding],
    );

    final hideAttachMenu = useCallback(
      () {
        if (!isAttachMenuShown) return;
        ref.read(attachMenuShownProvider.notifier).hide();
        textFieldFocusNode.requestFocus();

        Future<void>.delayed(const Duration(milliseconds: 600)).then((_) {
          if (!isAttachMenuShown) cachePadding.value = 0;
        });
      },
      [isAttachMenuShown, textFieldFocusNode],
    );

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.s, 8.s, 14.0.s, 8.s),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 6.0.s,
                children: [
                  ChatAttachmentMenuSwitchButton(
                    onTap: () async {
                      isTogglingBottomView.value = true;
                      if (isAttachMenuShown) {
                        hideAttachMenu();
                      } else {
                        showAttachMenu();
                        await Future<void>.delayed(const Duration(milliseconds: 600));
                      }
                      isTogglingBottomView.value = false;
                    },
                  ),
                  ChatTextField(
                    textFieldController: textFieldController,
                    textFieldFocusNode: textFieldFocusNode,
                    onSubmitted: onSubmitted,
                  ),
                  Column(
                    children: [
                      TextMessageLimitLabel(textEditingController: textFieldController),
                      ChatInputBarCameraButton(onSubmitted: onSubmitted),
                    ],
                  ),
                  ActionButton(
                    textFieldController: textFieldController,
                    recorderController: voiceRecorderController.value,
                    onSubmitted: isTextLimitReached.value
                        ? null
                        : () async {
                            if (recordedMediaFile.value != null) {
                              unawaited(
                                onSubmitted(
                                  content: textFieldController.text,
                                  mediaFiles: [recordedMediaFile.value!],
                                ),
                              );
                            } else {
                              unawaited(onSubmitted(content: textFieldController.text));
                            }
                            textFieldController.clear();
                            recordedMediaFile.value = null;
                          },
                  ),
                ],
              ),
              ChatInputBarRecordingOverlay(
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
                  ref.invalidate(voiceRecordingActiveStateProvider);
                  voiceRecorderController.value.reset();
                  recordedMediaFile.value = null;
                },
                recorderController: voiceRecorderController.value,
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: bottomViewInset,
            child: ChatAttachMenu(
              onSubmitted: ({content, mediaFiles}) {
                return Future.value();
              },
              receiverPubKey: receiverMasterPubkey,
            ),
          ),
        ],
      ),
    );
  }
}
