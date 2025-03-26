// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/components/character_limit_exceed_indicator/character_limit_exceed_indicator.dart';
import 'package:ion/app/features/feed/create_post/views/components/post_submit_button/post_submit_button.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/attached_media_preview.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/reply_author_header.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_bold_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_image_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_italic_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_poll_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_regular_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/typedefs/typedefs.dart';
import 'package:ion/generated/assets.gen.dart';

class ReplyInputField extends HookConsumerWidget {
  const ReplyInputField({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  Future<void> _openCreatePostRoute({
    required BuildContext context,
    required QuillController textEditorController,
    required FocusNode focusNode,
    required AttachedMediaNotifier attachedMediaNotifier,
    required AttachedMediaLinksNotifier attachedMediaLinksNotifier,
  }) async {
    final attachedMedia =
        attachedMediaNotifier.value.isNotEmpty ? jsonEncode(attachedMediaNotifier.value) : null;

    await CreateReplyRoute(
      parentEvent: eventReference.encode(),
      content: jsonEncode(
        textEditorController.document.toDelta().toJson(),
      ),
      attachedMedia: attachedMedia,
    ).push<Object?>(context);

    _clear(
      focusNode: focusNode,
      attachedMediaNotifier: attachedMediaNotifier,
      textEditorController: textEditorController,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController();
    final textEditorKey = useMemoized(TextEditorKeys.replyInput);
    final currentUserMetadata = ref.watch(currentUserMetadataProvider).valueOrNull;

    final inputContainerKey = useRef(GlobalKey());
    final focusNode = useFocusNode();
    final hasFocus = useNodeFocused(focusNode);
    final attachedMediaNotifier = useState(<MediaFile>[]);
    final attachedMediaLinksNotifier = useState<Map<String, MediaAttachment>>({});

    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            Padding(
              padding: EdgeInsets.only(bottom: 12.0.s),
              child: ReplyAuthorHeader(pubkey: eventReference.pubkey),
            ),
          Row(
            children: [
              if (!hasFocus.value && currentUserMetadata != null)
                Avatar(
                  imageUrl: currentUserMetadata.data.picture,
                  size: 36.0.s,
                  borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
                ),
              SizedBox(width: 6.0.s),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.theme.appColors.onSecondaryBackground,
                    borderRadius: BorderRadius.circular(16.0.s),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (attachedMediaNotifier.value.isNotEmpty) ...[
                        SizedBox(height: 6.0.s),
                        AttachedMediaPreview(
                          attachedMediaNotifier: attachedMediaNotifier,
                          attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                        ),
                      ],
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 9.0.s),
                        // When we focus the TextField, a new child is added to the Column,
                        // This causes Flutter to rebuild all subsequent children from scratch,
                        // which results in the TextField losing focus and the keyboard hiding.
                        // Assigning a key to this child ensures that Flutter preserves it during rebuilds.
                        key: inputContainerKey.value,
                        constraints: BoxConstraints(
                          maxHeight: 68.0.s,
                          minHeight: 36.0.s,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextEditor(
                                textEditorController,
                                focusNode: focusNode,
                                autoFocus: false,
                                placeholder: context.i18n.post_reply_hint,
                                key: textEditorKey,
                              ),
                            ),
                            if (hasFocus.value)
                              GestureDetector(
                                onTap: () async {
                                  await _openCreatePostRoute(
                                    context: context,
                                    textEditorController: textEditorController,
                                    focusNode: focusNode,
                                    attachedMediaNotifier: attachedMediaNotifier,
                                    attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                                  );
                                },
                                child: Assets.svg.iconReplysearchScale.icon(size: 20.0.s),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            ActionsToolbar(
              actions: [
                ToolbarImageButton(
                  delegate: AttachedMediaHandler(attachedMediaNotifier),
                  maxImages: ModifiablePostEntity.contentMediaLimit,
                ),
                ToolbarPollButton(
                  textEditorController: textEditorController,
                  onPressed: () async {
                    await _openCreatePostRoute(
                      context: context,
                      textEditorController: textEditorController,
                      focusNode: focusNode,
                      attachedMediaNotifier: attachedMediaNotifier,
                      attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                    );
                  },
                ),
                ToolbarRegularButton(textEditorController: textEditorController),
                ToolbarItalicButton(textEditorController: textEditorController),
                ToolbarBoldButton(textEditorController: textEditorController),
              ],
              trailing: Row(
                children: [
                  CharacterLimitExceedIndicator(
                    maxCharacters: ModifiablePostEntity.contentCharacterLimit,
                    textEditorController: textEditorController,
                  ),
                  SizedBox(width: 8.0.s),
                  PostSubmitButton(
                    textEditorController: textEditorController,
                    parentEvent: eventReference,
                    mediaFiles: attachedMediaNotifier.value,
                    createOption: CreatePostOption.reply,
                    onSubmitted: () {
                      _clear(
                        focusNode: focusNode,
                        attachedMediaNotifier: attachedMediaNotifier,
                        textEditorController: textEditorController,
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _clear({
    required FocusNode focusNode,
    required ValueNotifier<List<MediaFile>> attachedMediaNotifier,
    required QuillController textEditorController,
  }) {
    focusNode.unfocus();
    attachedMediaNotifier.value = [];

    /// calling `.replaceText` instead of `.clear` due to missing `ignoreFocus` parameter.
    textEditorController.replaceText(
      0,
      textEditorController.plainTextEditingValue.text.length - 1,
      '',
      const TextSelection.collapsed(offset: 0),
      ignoreFocus: true,
    );
  }
}
