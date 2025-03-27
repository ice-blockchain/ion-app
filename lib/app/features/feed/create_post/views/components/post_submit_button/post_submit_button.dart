// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion_content_labeler/ion_content_labeler.dart';

class PostSubmitButton extends HookConsumerWidget {
  const PostSubmitButton({
    required this.textEditorController,
    required this.createOption,
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.modifiedEvent,
    this.mediaFiles = const [],
    this.onSubmitted,
  });

  final QuillController textEditorController;

  final EventReference? parentEvent;

  final EventReference? quotedEvent;

  final EventReference? modifiedEvent;

  final List<MediaFile> mediaFiles;

  final CreatePostOption createOption;

  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasContent = useTextEditorHasContent(textEditorController) || mediaFiles.isNotEmpty;
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);
    final hasPoll = useHasPoll(textEditorController);
    // final whoCanReply = ref.watch(selectedWhoCanReplyOptionProvider);

    final isSubmitButtonEnabled = useMemoized(
      () {
        if (hasPoll) {
          final isPoolValid = Validators.isPollValid(
            pollTitle.text,
            pollAnswers.map((answer) => answer.text).toList(),
          );
          return isPoolValid;
        } else {
          return hasContent;
        }
      },
      [hasPoll, hasContent],
    );

    return ToolbarSendButton(
      enabled: isSubmitButtonEnabled,
      onPressed: () async {
        final content = textEditorController.document.toPlainText().trim();
        final labeler = IonTextLabeler();
        final language = await labeler.detectTextLanguage(content);
        final category = await labeler.detectTextCategory(content);
        if (context.mounted) {
          await showSimpleBottomSheet<void>(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigationAppBar.modal(
                  showBackButton: false,
                  title: const Text('Labeling results'),
                ),
                Text('languages:\n${language.labels.join('\n')}\n', textAlign: TextAlign.left),
                Text('categories:\n${category.labels.join('\n')}\n', textAlign: TextAlign.left),
                Text('input: ${category.input}', textAlign: TextAlign.left),
                ScreenBottomOffset(),
              ],
            ),
            context: context,
          );
        }
        // if (modifiedEvent != null) {
        //   unawaited(
        //     ref
        //         .read(
        //           createPostNotifierProvider(
        //             createOption,
        //           ).notifier,
        //         )
        //         .modify(
        //           content: textEditorController.document.toDelta(),
        //           eventReference: modifiedEvent!,
        //           whoCanReply: whoCanReply,
        //         ),
        //   );
        // } else {
        //   final convertedMediaFiles = await ref
        //       .read(mediaServiceProvider)
        //       .convertAssetIdsToMediaFiles(ref, mediaFiles: mediaFiles);
        //   unawaited(
        //     ref
        //         .read(
        //           createPostNotifierProvider(
        //             createOption,
        //           ).notifier,
        //         )
        //         .create(
        //           content: textEditorController.document.toDelta(),
        //           parentEvent: parentEvent,
        //           quotedEvent: quotedEvent,
        //           mediaFiles: convertedMediaFiles,
        //           whoCanReply: whoCanReply,
        //         ),
        //   );
        // }

        // if (onSubmitted != null) {
        //   onSubmitted!();
        // } else if (context.mounted) {
        //   ref.context.pop(true);
        // }
      },
    );
  }
}
