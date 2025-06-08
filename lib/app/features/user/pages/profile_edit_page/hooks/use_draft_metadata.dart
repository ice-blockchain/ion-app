// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';

({
  bool hasChanges,
  ObjectRef<UserMetadata> draftRef,
  void Function(UserMetadata) update,
}) useDraftMetadata(WidgetRef ref, UserMetadata userMetadata) {
  final draftRef = useRef(userMetadata.copyWith());
  final hasChanges = useState(false);

  final avatarFile = ref.watch(
    imageProcessorNotifierProvider(ImageProcessingType.avatar)
        .select((state) => state.whenOrNull(processed: (file) => file)),
  );
  final bannerFile = ref.watch(
    imageProcessorNotifierProvider(ImageProcessingType.banner)
        .select((state) => state.whenOrNull(processed: (file) => file)),
  );

  void update(UserMetadata userMetadataUpdated) {
    draftRef.value = userMetadataUpdated;
    hasChanges.value = draftRef.value != userMetadata;
  }

  return (
    hasChanges: hasChanges.value || avatarFile != null || bannerFile != null,
    draftRef: draftRef,
    update: update,
  );
}
