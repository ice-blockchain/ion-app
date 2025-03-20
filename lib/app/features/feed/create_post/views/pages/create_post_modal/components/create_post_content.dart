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
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/current_user_avatar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/quoted_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_cover.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_url_links.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class CreatePostContent extends StatelessWidget {
  const CreatePostContent({
    required this.scrollController,
    required this.attachedVideoNotifier,
    required this.parentEvent,
    required this.textEditorController,
    required this.createOption,
    required this.attachedMediaNotifier,
    required this.quotedEvent,
    super.key,
  });

  final ScrollController scrollController;
  final ValueNotifier<MediaFile?> attachedVideoNotifier;
  final EventReference? parentEvent;
  final QuillController textEditorController;
  final CreatePostOption createOption;
  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;
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
            KeyboardVisibilityProvider(
              child: _TextInputSection(
                textEditorController: textEditorController,
                createOption: createOption,
                attachedMediaNotifier: attachedMediaNotifier,
              ),
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
  });

  final QuillController textEditorController;
  final CreatePostOption createOption;
  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaFiles = attachedMediaNotifier.value;
    final textEditorKey = useMemoized(TextEditorKeys.createPost);
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    useOnInit(
      () {
        if (textEditorKey.currentContext != null && isKeyboardVisible) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Scrollable.ensureVisible(
              textEditorKey.currentContext!,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
          });
        }
      },
      [isKeyboardVisible],
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
                  if (mediaFiles.isNotEmpty) ...[
                    SizedBox(height: 12.0.s),
                    AttachedMediaPreview(
                      attachedMediaNotifier: attachedMediaNotifier,
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
