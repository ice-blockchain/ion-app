// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/components/create_article_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class CreateArticleModal extends HookConsumerWidget {
  const CreateArticleModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController();

    Future<bool?> showCancelCreationModal(BuildContext context) {
      return showSimpleBottomSheet<bool>(
        context: context,
        child: CancelCreationModal(
          title: context.i18n.cancel_creation_article_title,
          onCancel: () => Navigator.of(context).pop(true),
        ),
      );
    }

    return BackHardwareButtonInterceptor(
      onBackPress: (context) async {
        await showCancelCreationModal(context);
      },
      child: SheetContent(
        bottomPadding: 0,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.create_article_nav_title),
              onBackPress: () {
                showCancelCreationModal(context);
              },
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
                CreateArticleToolbar(
                  textEditorController: textEditorController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
