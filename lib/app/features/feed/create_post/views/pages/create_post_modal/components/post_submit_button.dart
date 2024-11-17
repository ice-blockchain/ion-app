import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.dart';
import 'package:ion/app/features/feed/content_notification/data/models/content_notification_data.dart';
import 'package:ion/app/features/feed/content_notification/providers/content_notification_provider.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/utils/validators.dart';

class PostSubmitButton extends HookConsumerWidget {
  const PostSubmitButton({required this.textEditorController, super.key});

  final QuillController textEditorController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasContent = useTextEditorHasContent(textEditorController);
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);
    final hasPoll = useHasPoll(textEditorController);
    final isSubmitLoading = ref.watch(createPostNotifierProvider).isLoading;
    ref.displayErrors(createPostNotifierProvider);

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

    final onSubmit = useCallback(({required String content, EventReference? parentEvent}) async {
      await ref
          .read(createPostNotifierProvider.notifier)
          .create(content: content, parentEvent: parentEvent);

      if (!ref.read(createPostNotifierProvider).hasError) {
        if (ref.context.mounted) {
          ref.context.pop();
        }
        ref.read(contentNotificationControllerProvider.notifier).showSuccess(ContentType.post);
      }
    });

    return ToolbarSendButton(
      loading: isSubmitLoading,
      enabled: isSubmitButtonEnabled && !isSubmitLoading,
      onPressed: () => onSubmit(content: textEditorController.document.toPlainText()),
    );
  }
}
