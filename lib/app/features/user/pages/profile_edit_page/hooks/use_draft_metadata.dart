// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.dart';
import 'package:ion/app/features/user/providers/banner_processor_notifier.dart';

({
  bool hasChanges,
  ObjectRef<UserMetadata> draftRef,
  void Function(UserMetadata) update,
}) useDraftMetadata(WidgetRef ref, UserMetadata userMetadata) {
  final draftRef = useRef(userMetadata.copyWith());
  final hasChanges = useState(false);

  final avatarFile = ref.watch(
    avatarProcessorNotifierProvider.select((state) => state.whenOrNull(processed: (file) => file)),
  );
  final bannerFile = ref.watch(
    bannerProcessorNotifierProvider.select((state) => state.whenOrNull(processed: (file) => file)),
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
