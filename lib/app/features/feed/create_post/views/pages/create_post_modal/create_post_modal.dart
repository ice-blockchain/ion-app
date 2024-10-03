// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_bold_button/text_editor_bold_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_image_button/text_editor_image_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_italic_button/text_editor_italic_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_poll_button/text_editor_poll_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_regular_button/text_editor_regular_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ice/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ice/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/app/services/markdown_parser/markdown_parser.dart';

class CreatePostModal extends HookWidget {
  const CreatePostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditorController = useQuillController();
    final hasContent = useTextEditorHasContent(textEditorController);

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_post_modal_title),
            onBackPress: () {
              showSimpleBottomSheet<void>(
                context: context,
                child: CancelCreationModal(
                  title: context.i18n.cancel_creation_post_title,
                  onCancel: () => Navigator.of(context).pop(),
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Avatar(
                          size: 30.0.s,
                          imageUrl:
                              'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                        ),
                        SizedBox(width: 10.0.s),
                        Expanded(
                          child: TextEditor(
                            textEditorController,
                            placeholder: context.i18n.create_post_modal_placeholder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const HorizontalSeparator(),
              ScreenSideOffset.small(
                child: ActionsToolbar(
                  actions: [
                    TextEditorImageButton(textEditorController: textEditorController),
                    TextEditorPollButton(textEditorController: textEditorController),
                    TextEditorRegularButton(textEditorController: textEditorController),
                    TextEditorItalicButton(textEditorController: textEditorController),
                    TextEditorBoldButton(textEditorController: textEditorController),
                  ],
                  trailing: ActionsToolbarButtonSend(
                    enabled: hasContent,
                    onPressed: () {
                      generateMarkdownFromDelta(textEditorController.document.toDelta());
                      context.pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
