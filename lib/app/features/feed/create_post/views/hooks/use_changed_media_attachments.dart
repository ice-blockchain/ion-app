// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

bool useChangedMediaAttachments(
  Map<String, MediaAttachment> mediaAttachments,
  IonConnectEntity? modifiedEvent,
) {
  final changedMediaAttachments = useState<bool>(false);

  useEffect(
    () {
      if (modifiedEvent == null || modifiedEvent is! ModifiablePostEntity) {
        changedMediaAttachments.value = false;
      } else {
        final existingAttachments = modifiedEvent.data.media;
        final currentAttachmentKeys = mediaAttachments.keys.toSet();
        final existingAttachmentKeys = existingAttachments.keys.toSet();
        final attachmentsMatch = currentAttachmentKeys.containsAll(existingAttachmentKeys) &&
            existingAttachmentKeys.containsAll(currentAttachmentKeys);
        changedMediaAttachments.value = !attachmentsMatch;
      }
      return null;
    },
    [mediaAttachments.length, modifiedEvent],
  );

  return changedMediaAttachments.value;
}
