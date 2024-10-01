// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/schedule_posting_provider.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_bold_button/text_editor_bold_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_image_button/text_editor_image_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_italic_button/text_editor_italic_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_poll_button/text_editor_poll_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/toolbar_buttons/text_editor_regular_button/text_editor_regular_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ice/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ice/app/features/feed/views/components/visibility_settings_toolbar/visibility_settings_toolbar.dart';
import 'package:ice/app/features/feed/views/pages/schedule_modal/schedule_modal.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class CreateArticleModal extends HookConsumerWidget {
  const CreateArticleModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController();
    final hasContent = useTextEditorHasContent(textEditorController);
    final date = ref.watch(schedulePostingProvider);

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_article_nav_title),
            actions: [
              Button(
                type: ButtonType.secondary,
                label: Text(
                  context.i18n.button_next,
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
                backgroundColor: context.theme.appColors.secondaryBackground,
                borderColor: context.theme.appColors.secondaryBackground,
                onPressed: context.pop,
              ),
            ],
          ),
          Expanded(
            child: ScreenSideOffset.small(
              child: TextEditor(
                textEditorController,
              ),
            ),
          ),
          Column(
            children: [
              const HorizontalSeparator(),
              ScreenSideOffset.small(
                child: const VisibilitySettingsToolbar(),
              ),
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
                  trailing: Row(
                    children: [
                      ActionsToolbarButton(
                        icon: Assets.svg.iconCreatepostShedule,
                        onPressed: () async {
                          final selectedDate = await showSimpleBottomSheet<DateTime>(
                            context: context,
                            child: ScheduleModal(
                              initialDate: date,
                            ),
                          );

                          if (selectedDate != null) {
                            ref.read(schedulePostingProvider.notifier).selectedDate = selectedDate;
                          }
                        },
                      ),
                      SizedBox(
                        width: 16.0.s,
                      ),
                      ActionsToolbarButtonSend(
                        enabled: hasContent,
                        onPressed: () {},
                      ),
                    ],
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
