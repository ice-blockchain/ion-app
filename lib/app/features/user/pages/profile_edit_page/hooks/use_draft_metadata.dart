// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';

({
  bool hasChanges,
  ObjectRef<UserMetadata> draftRef,
  void Function(UserMetadata) update,
}) useDraftMetadata(UserMetadata userMetadata) {
  final draftRef = useRef(userMetadata.copyWith());
  final hasChanges = useState(false);

  void update(UserMetadata userMetadataUpdated) {
    draftRef.value = userMetadataUpdated;
    hasChanges.value = draftRef.value != userMetadata;
  }

  return (hasChanges: hasChanges.value, draftRef: draftRef, update: update);
}
