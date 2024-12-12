// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/components/post_submit_button/post_submit_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/attached_media_preview_list.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/collaple_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/current_user_avatar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/quoted_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_cover.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_keyboard_scroll_handler.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_buttons.dart';
import 'package:ion/app/features/feed/views/components/visibility_settings_toolbar/visibility_settings_toolbar.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class CreatePostModal extends HookConsumerWidget {
  const CreatePostModal({
    required this.showCollapseButton,
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.content,
    this.videoPath,
  });

  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final String? content;
  final bool showCollapseButton;
  final String? videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController = useQuillController(defaultText: content);
    final scrollController = useScrollController();

    final visibilityToolbarKey = useMemoized(GlobalKey.new);
    final actionsToolbarKey = useMemoized(GlobalKey.new);
    final textInputKey = useMemoized(GlobalKey.new);

    useKeyboardScrollHandler(
      scrollController: scrollController,
      keysToMeasure: [visibilityToolbarKey, actionsToolbarKey, textInputKey],
    );

    final createOption = videoPath != null
        ? CreatePostOption.video
        : parentEvent != null
            ? CreatePostOption.reply
            : quotedEvent != null
                ? CreatePostOption.quote
                : CreatePostOption.plain;

    Future<void> onBack() async =>
        textEditorController.document.isEmpty() ? context.pop() : _showCancelCreationModal(context);

    final attachedMediaNotifier = useState<List<MediaFile>>([]);

    return BackHardwareButtonInterceptor(
      onBackPress: (_) => onBack(),
      child: SheetContent(
        topPadding: 0,
        body: Column(
          children: [
            NavigationAppBar.modal(
              title: Text(
                createOption.getTitle(context),
              ),
              onBackPress: onBack,
              actions: [
                if (showCollapseButton) CollapseButton(textEditorController: textEditorController),
              ],
            ),
            Expanded(
              child: KeyboardDismissOnTap(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      if (videoPath != null)
                        ScreenSideOffset.small(
                          child: VideoPreviewCover(videoPath: videoPath!),
                        ),
                      if (parentEvent != null)
                        ScreenSideOffset.small(
                          child: ParentEntity(eventReference: parentEvent!),
                        ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0.s),
                        child: Row(
                          key: textInputKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenSideOffset.defaultSmallMargin,
                              ),
                              child: const CurrentUserAvatar(),
                            ),
                            SizedBox(width: 10.0.s),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 6.0.s,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextEditor(
                                      textEditorController,
                                      placeholder: createOption.getPlaceholder(context),
                                    ),
                                    if (attachedMediaNotifier.value.isNotEmpty) ...[
                                      SizedBox(height: 12.0.s),
                                      AttachedMediaPreview(
                                        attachedMediaNotifier: attachedMediaNotifier,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (quotedEvent != null)
                        ScreenSideOffset.small(
                          child: QuotedEntity(eventReference: quotedEvent!),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const HorizontalSeparator(),
            ScreenSideOffset.small(
              key: visibilityToolbarKey,
              child: const VisibilitySettingsToolbar(),
            ),
            ScreenSideOffset.small(
              key: actionsToolbarKey,
              child: ActionsToolbar(
                actions: [
                  ToolbarImageButton(
                    delegate: AttachedMediaHandler(attachedMediaNotifier),
                  ),
                  ToolbarPollButton(textEditorController: textEditorController),
                  ToolbarRegularButton(textEditorController: textEditorController),
                  ToolbarItalicButton(textEditorController: textEditorController),
                  ToolbarBoldButton(textEditorController: textEditorController),
                ],
                trailing: PostSubmitButton(
                  textEditorController: textEditorController,
                  parentEvent: parentEvent,
                  quotedEvent: quotedEvent,
                  attachedMedia: attachedMediaNotifier.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCancelCreationModal(BuildContext context) async {
    await showSimpleBottomSheet<void>(
      context: context,
      child: CancelCreationModal(
        title: context.i18n.cancel_creation_post_title,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
