// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_character_limit_exceed_amount.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.c.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/validators.dart';

class PostSubmitButton extends HookConsumerWidget {
  const PostSubmitButton({
    required this.textEditorController,
    required this.createOption,
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.modifiedEvent,
    this.mediaFiles = const [],
    this.mediaAttachments = const {},
    this.onSubmitted,
  });

  final QuillController textEditorController;
  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final EventReference? modifiedEvent;
  final List<MediaFile> mediaFiles;
  final Map<String, MediaAttachment> mediaAttachments;
  final CreatePostOption createOption;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasContent = useTextEditorHasContent(textEditorController) || mediaFiles.isNotEmpty;
    final exceedsCharacterLimit = useTextEditorCharacterLimitExceedAmount(
          textEditorController,
          ModifiablePostEntity.contentCharacterLimit,
        ) >
        0;
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);
    final hasPoll = useHasPoll(textEditorController);

    final isLoading = useState(false);

    final isSubmitButtonEnabled = useMemoized(
      () {
        if (isLoading.value) return false;

        final contentValid = hasPoll
            ? Validators.isPollValid(
                pollTitle.text,
                pollAnswers,
              )
            : hasContent;

        return contentValid && !exceedsCharacterLimit;
      },
      [hasPoll, hasContent, exceedsCharacterLimit, isLoading.value],
    );

    return ToolbarSendButton(
      enabled: isSubmitButtonEnabled,
      isLoading: isLoading.value,
      onPressed: () async {
        if (!isSubmitButtonEnabled) return;

        try {
          isLoading.value = true;
          await _handlePostSubmission(ref, context);
        } catch (e) {
          // Show error message to user
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to submit post: $e')),
            );
          }
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> _handlePostSubmission(WidgetRef ref, BuildContext context) async {
    final convertedMediaFiles = await ref
        .read(mediaServiceProvider)
        .convertAssetIdsToMediaFiles(ref, mediaFiles: mediaFiles);

    final createPostNotifier = ref.read(
      createPostNotifierProvider(createOption).notifier,
    );

    final whoCanReply = ref.read(selectedWhoCanReplyOptionProvider);
    final content = textEditorController.document.toDelta();

    if (modifiedEvent != null) {
      await createPostNotifier.modify(
        content: content,
        mediaFiles: convertedMediaFiles,
        mediaAttachments: mediaAttachments,
        eventReference: modifiedEvent!,
        whoCanReply: whoCanReply,
      );
    } else {
      await createPostNotifier.create(
        content: content,
        parentEvent: parentEvent,
        quotedEvent: quotedEvent,
        mediaFiles: convertedMediaFiles,
        whoCanReply: whoCanReply,
      );
    }

    if (onSubmitted != null) {
      onSubmitted!();
    } else if (context.mounted) {
      ref.context.pop(true);
    }
  }
}
