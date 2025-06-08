// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_character_limit_exceed_amount.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/feed/create_post/views/hooks/use_changed_media_attachments.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/polls/data/models/poll_answer.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/app/utils/validators.dart';

bool useCanSubmitPost({
  required QuillController textEditorController,
  required List<MediaFile> mediaFiles,
  required Map<String, MediaAttachment> mediaAttachments,
  required bool hasPoll,
  required List<PollAnswer> pollAnswers,
  IonConnectEntity? modifiedEvent,
}) {
  final hasContent = useTextEditorHasContent(textEditorController);
  final hasMediaFiles = mediaFiles.isNotEmpty;
  final hasMediaAttachments = mediaAttachments.isNotEmpty;
  final changedMediaAttachments = useChangedMediaAttachments(
    mediaAttachments,
    modifiedEvent,
  );
  final exceedsCharacterLimit = useTextEditorCharacterLimitExceedAmount(
        textEditorController,
        ModifiablePostEntity.contentCharacterLimit,
      ) >
      0;
  final canSubmit = useState<bool>(false);

  useEffect(
    () {
      final isPollValid = !hasPoll ||
          Validators.isPollValid(
            pollAnswers,
          );

      final isEditMode = modifiedEvent != null;

      bool hasAnyContent;
      if (isEditMode) {
        hasAnyContent = hasContent || hasMediaAttachments || hasMediaFiles;
      } else {
        hasAnyContent = hasContent || hasMediaFiles;
      }

      final shouldEnableSubmit = isPollValid && !exceedsCharacterLimit && hasAnyContent;

      canSubmit.value = shouldEnableSubmit;
      return null;
    },
    [
      hasContent,
      hasMediaFiles,
      hasMediaAttachments,
      exceedsCharacterLimit,
      hasPoll,
      changedMediaAttachments,
      pollAnswers,
      modifiedEvent,
    ],
  );

  return canSubmit.value;
}
