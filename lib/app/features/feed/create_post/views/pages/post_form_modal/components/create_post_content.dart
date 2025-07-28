// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/attached_media_preview.dart';
import 'package:ion/app/features/feed/create_post/views/components/topics/topics_button.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/current_user_avatar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/parent_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/quoted_entity.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/video_preview_cover.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/hooks/use_url_links.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/polls/providers/poll_draft_provider.r.dart';
import 'package:ion/app/features/feed/polls/view/components/poll.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
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
    required this.textEditorKey,
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
  final GlobalKey<TextEditorState> textEditorKey;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VideoPreviewSection(attachedVideoNotifier: attachedVideoNotifier),
            _TopicsSection(
              attachedMediaNotifier: attachedMediaNotifier,
              attachedVideoNotifier: attachedVideoNotifier,
              attachedMediaLinksNotifier: attachedMediaLinksNotifier,
              parentEvent: parentEvent,
              quotedEvent: quotedEvent,
            ),
            if (parentEvent != null) _ParentEntitySection(eventReference: parentEvent!),
            _TextInputSection(
              textEditorController: textEditorController,
              createOption: createOption,
              attachedMediaNotifier: attachedMediaNotifier,
              attachedMediaLinksNotifier: attachedMediaLinksNotifier,
              textEditorKey: textEditorKey,
              scrollController: scrollController,
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
      child: Center(
        child: VideoPreviewCover(attachedVideoNotifier: attachedVideoNotifier),
      ),
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
    required this.textEditorKey,
    required this.scrollController,
  });

  final QuillController textEditorController;
  final CreatePostOption createOption;
  final AttachedMediaNotifier attachedMediaNotifier;
  final AttachedMediaLinksNotifier attachedMediaLinksNotifier;
  final GlobalKey<TextEditorState> textEditorKey;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaFiles = attachedMediaNotifier.value;
    final mediaLinks = attachedMediaLinksNotifier.value.values.toList();
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final draftPoll = ref.watch(pollDraftNotifierProvider);

    final links = useUrlLinks(
      textEditorController: textEditorController,
      mediaFiles: mediaFiles,
    );

    useEffect(
      () {
        if (bottomInset > 0 && textEditorKey.currentContext != null) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (textEditorKey.currentContext != null) {
              Scrollable.ensureVisible(
                textEditorKey.currentContext!,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        return null;
      },
      [bottomInset],
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.0.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: ScreenSideOffset.defaultSmallMargin,
            ),
            child: const CurrentUserAvatar(),
          ),
          SizedBox(width: 10.0.s),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 6.0.s,
                end: ScreenSideOffset.defaultSmallMargin,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextEditor(
                    textEditorController,
                    placeholder: createOption.getPlaceholder(context),
                    key: textEditorKey,
                    scrollController: scrollController,
                  ),
                  if (draftPoll.added) ...[
                    SizedBox(height: 12.0.s),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 23.0.s),
                      child: Poll(
                        onRemove: () {
                          ref.read(pollDraftNotifierProvider.notifier).reset();
                        },
                      ),
                    ),
                  ],
                  if (mediaFiles.isNotEmpty || mediaLinks.isNotEmpty) ...[
                    SizedBox(height: 12.0.s),
                    AttachedMediaPreview(
                      attachedMediaNotifier: attachedMediaNotifier,
                      attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                    ),
                  ],
                  if (mediaFiles.isEmpty && links.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 10.0.s,
                      ),
                      child: UrlPreviewContent(
                        url: links.first,
                        clickable: false,
                      ),
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

class _TopicsSection extends HookConsumerWidget {
  const _TopicsSection({
    required this.attachedMediaNotifier,
    required this.attachedVideoNotifier,
    required this.attachedMediaLinksNotifier,
    required this.parentEvent,
    required this.quotedEvent,
  });

  final AttachedMediaNotifier attachedMediaNotifier;
  final ValueNotifier<MediaFile?> attachedVideoNotifier;
  final AttachedMediaLinksNotifier attachedMediaLinksNotifier;
  final EventReference? parentEvent;
  final EventReference? quotedEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // inherit topics from parent or quoted event
    if (parentEvent != null || quotedEvent != null) {
      return const SizedBox.shrink();
    }

    final isAnyMediaVideo = attachedMediaNotifier.value.any(
      (media) {
        final mediaType = MediaType.fromMimeType(media.mimeType.emptyOrValue);
        return mediaType == MediaType.video;
      },
    );
    final isAnyMediaLinkVideo = attachedMediaLinksNotifier.value.values.any(
      (mediaLink) {
        return mediaLink.mediaType == MediaType.video;
      },
    );
    final isVideo = attachedVideoNotifier.value != null || isAnyMediaVideo || isAnyMediaLinkVideo;

    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 8.s),
        child: TopicsButton(
          type: isVideo ? FeedType.video : FeedType.post,
        ),
      ),
    );
  }
}
