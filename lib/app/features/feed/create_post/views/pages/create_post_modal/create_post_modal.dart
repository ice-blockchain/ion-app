// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/providers/reply_data_notifier.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/collaple_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/post_submit_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/quoted_entity.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_buttons.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class CreatePostModal extends HookConsumerWidget {
  const CreatePostModal({
    required this.showCollapseButton,
    super.key,
    this.parentEvent,
    this.quotedEvent,
  });

  final EventReference? parentEvent;

  final EventReference? quotedEvent;

  final bool showCollapseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController =
        useQuillController(defaultText: ref.watch(replyDataNotifierProvider));

    final currentUserPicture = ref.watch(currentUserMetadataProvider).valueOrNull?.data.picture;

    Future<void> onBack() async =>
        textEditorController.document.isEmpty() ? context.pop() : _showCancelCreationModal(context);

    return BackHardwareButtonInterceptor(
      onBackPress: (_) => onBack(),
      child: SheetContent(
        topPadding: 0,
        body: Column(
          children: [
            NavigationAppBar.modal(
              title: Text(
                parentEvent != null
                    ? context.i18n.post_reply
                    : quotedEvent != null
                        ? context.i18n.feed_write_comment
                        : context.i18n.create_post_modal_title,
              ),
              onBackPress: onBack,
              actions: [if (showCollapseButton) const CollapseButton()],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ScreenSideOffset.small(
                  child: Column(
                    children: [
                      if (parentEvent != null) ParentEntity(eventReference: parentEvent!),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(size: 30.0.s, imageUrl: currentUserPicture),
                          SizedBox(width: 10.0.s),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.0.s),
                              child: TextEditor(
                                textEditorController,
                                placeholder: context.i18n.create_post_modal_placeholder,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (quotedEvent != null) QuotedEntity(eventReference: quotedEvent!),
                    ],
                  ),
                ),
              ),
            ),
            const HorizontalSeparator(),
            ScreenSideOffset.small(
              child: ActionsToolbar(
                actions: [
                  ToolbarImageButton(textEditorController: textEditorController),
                  ToolbarPollButton(textEditorController: textEditorController),
                  ToolbarRegularButton(textEditorController: textEditorController),
                  ToolbarItalicButton(textEditorController: textEditorController),
                  ToolbarBoldButton(textEditorController: textEditorController),
                ],
                trailing: PostSubmitButton(
                  textEditorController: textEditorController,
                  parentEvent: parentEvent,
                  quotedEvent: quotedEvent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCancelCreationModal(
    BuildContext context,
  ) async {
    await showSimpleBottomSheet<void>(
      context: context,
      child: CancelCreationModal(
        title: context.i18n.cancel_creation_post_title,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
