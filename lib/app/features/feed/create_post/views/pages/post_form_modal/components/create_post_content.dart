// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/attached_media_preview.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/current_user_avatar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/quoted_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/video_preview_cover.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/hooks/use_url_links.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/typedefs/typedefs.dart';

class CreatePostContent extends StatelessWidget {
  const CreatePostContent({
    required this.scrollController,
    required this.attachedVideoNotifier,
    required this.parentEvent,
    required this.textEditorController,
    required this.createOption,
    required this.attachedMediaNotifier,
    required this.attachedMediaLinksNotifier,
    required this.quotedEvent,
    super.key,
  });

  final ScrollController scrollController;
  final ValueNotifier<MediaFile?> attachedVideoNotifier;
  final EventReference? parentEvent;
  final QuillController textEditorController;
  final CreatePostOption createOption;
  final AttachedMediaNotifier attachedMediaNotifier;
  final AttachedMediaLinksNotifier attachedMediaLinksNotifier;
  final EventReference? quotedEvent;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _VideoPreviewSection(attachedVideoNotifier: attachedVideoNotifier),
            if (parentEvent != null) _ParentEntitySection(eventReference: parentEvent!),
            _TextInputSection(
              textEditorController: textEditorController,
              createOption: createOption,
              attachedMediaNotifier: attachedMediaNotifier,
              attachedMediaLinksNotifier: attachedMediaLinksNotifier,
            ),
            if (quotedEvent != null) _QuotedEntitySection(eventReference: quotedEvent!),
          ],
        ),
      ),
    );
  }
}

class _VideoPreviewSection extends StatelessWidget {
  const _VideoPreviewSection({
    required this.attachedVideoNotifier,
  });

  final ValueNotifier<MediaFile?> attachedVideoNotifier;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: VideoPreviewCover(attachedVideoNotifier: attachedVideoNotifier),
    );
  }
}

class _ParentEntitySection extends StatelessWidget {
  const _ParentEntitySection({
    required this.eventReference,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: IgnorePointer(
        child: ParentEntity(eventReference: eventReference),
      ),
    );
  }
}

class _TextInputSection extends HookConsumerWidget {
  const _TextInputSection({
    required this.textEditorController,
    required this.createOption,
    required this.attachedMediaNotifier,
    required this.attachedMediaLinksNotifier,
  });

  final QuillController textEditorController;
  final CreatePostOption createOption;
  final AttachedMediaNotifier attachedMediaNotifier;
  final AttachedMediaLinksNotifier attachedMediaLinksNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaFiles = attachedMediaNotifier.value;
    final mediaLinks = attachedMediaLinksNotifier.value.values.toList();
    final textEditorKey = useMemoized(TextEditorKeys.createPost);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    useEffect(
      () {
        if (bottomInset > 0 && textEditorKey.currentContext != null) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Scrollable.ensureVisible(
              textEditorKey.currentContext!,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
          });
        }
        return null;
      },
      [bottomInset],
    );

    final links = useUrlLinks(
      textEditorController: textEditorController,
      mediaFiles: mediaFiles,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0.s),
      child: Row(
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
                right: ScreenSideOffset.defaultSmallMargin,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextEditor(
                    textEditorController,
                    placeholder: createOption.getPlaceholder(context),
                    key: textEditorKey,
                  ),
                  if (mediaFiles.isNotEmpty || mediaLinks.isNotEmpty) ...[
                    SizedBox(height: 12.0.s),
                    AttachedMediaPreview(
                      attachedMediaNotifier: attachedMediaNotifier,
                      attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                    ),
                  ],
                  if (mediaFiles.isEmpty && links.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0.s,
                      ),
                      child: UrlPreviewContent(url: links.first),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotedEntitySection extends StatelessWidget {
  const _QuotedEntitySection({
    required this.eventReference,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: IgnorePointer(
        child: QuotedEntity(eventReference: eventReference),
      ),
    );
  }
}
