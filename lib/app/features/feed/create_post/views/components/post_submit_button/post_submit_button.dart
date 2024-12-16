// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/poll/poll_answers_provider.c.dart';
import 'package:ion/app/features/core/providers/poll/poll_title_notifier.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/validators.dart';

class PostSubmitButton extends HookConsumerWidget {
  const PostSubmitButton({
    required this.textEditorController,
    required this.createOption,
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.mediaFiles = const [],
  });

  final QuillController textEditorController;

  final EventReference? parentEvent;

  final EventReference? quotedEvent;

  final List<MediaFile> mediaFiles;

  final CreatePostOption createOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasContent = useTextEditorHasContent(textEditorController) || mediaFiles.isNotEmpty;
    final pollTitle = ref.watch(pollTitleNotifierProvider);
    final pollAnswers = ref.watch(pollAnswersNotifierProvider);
    final hasPoll = useHasPoll(textEditorController);

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
        final operations = textEditorController.document.toDelta().operations;
        final convertedMediaFiles = await _convertToMediaFiles(ref, mediaFiles: mediaFiles);

        unawaited(
          ref
              .read(
                createPostNotifierProvider(
                  createOption,
                ).notifier,
              )
              .create(
                content: Document.fromDelta(Delta.fromOperations(operations)).toPlainText(),
                parentEvent: parentEvent,
                quotedEvent: quotedEvent,
                mediaFiles: convertedMediaFiles,
              ),
        );

        if (context.mounted) {
          ref.context.pop();
        }
      },
    );
  }

  // Convert all asset media id-s returned from MediaPicker to actual file path-es
  Future<List<MediaFile>> _convertToMediaFiles(
    WidgetRef ref, {
    required List<MediaFile> mediaFiles,
  }) async {
    return Future.wait(
      mediaFiles.map((mediaFile) async {
        final assetEntity = await ref.read(assetEntityProvider(mediaFile.path).future);
        if (assetEntity == null) {
          throw AssetEntityFileNotFoundException();
        }
        final (mimeType, file) = await (assetEntity.mimeTypeAsync, assetEntity.file).wait;
        if (file == null) {
          throw AssetEntityFileNotFoundException();
        }
        return MediaFile(
          path: file.path,
          height: assetEntity.height,
          width: assetEntity.width,
          mimeType: mimeType,
          thumb: mediaFile.thumb,
        );
      }),
    );
  }
}
