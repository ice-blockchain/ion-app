// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_character_limit_exceed_amount.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_has_content.dart';
import 'package:ion/app/features/feed/create_post/views/hooks/use_changed_media_attachments.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_answer.c.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_title_data.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/validators.dart';

bool useCanSubmitPost(
  QuillController textEditorController,
  List<MediaFile> mediaFiles,
  Map<String, MediaAttachment> mediaAttachments,
  PollTitleData pollTitle,
  List<PollAnswer> pollAnswers,
  IonConnectEntity? modifiedEvent,
) {
  final hasContent = useTextEditorHasContent(textEditorController) || mediaFiles.isNotEmpty;
  final changedMediaAttachments = useChangedMediaAttachments(
    mediaAttachments,
    modifiedEvent,
  );
  final exceedsCharacterLimit = useTextEditorCharacterLimitExceedAmount(
        textEditorController,
        ModifiablePostEntity.contentCharacterLimit,
      ) >
      0;
  final hasPoll = useHasPoll(textEditorController);
  final canSubmit = useState<bool>(false);

  useEffect(
    () {
      final isPollValid = !hasPoll ||
          Validators.isPollValid(
            pollTitle.text,
            pollAnswers,
          );
      canSubmit.value =
          isPollValid && (hasContent || changedMediaAttachments) && !exceedsCharacterLimit;
      return null;
    },
    [hasContent, exceedsCharacterLimit, hasPoll, changedMediaAttachments, pollTitle, pollAnswers],
  );

  return canSubmit.value;
}
