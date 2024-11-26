// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';

({
  bool hasChanges,
  ObjectRef<UserMetadata> userMetadataDraftRef,
  void Function(UserMetadata) update,
}) useDraftMetadata(UserMetadata userMetadata) {
  final userMetadataDraftRef = useRef(userMetadata.copyWith());
  final hasChanges = useState(false);

  void update(UserMetadata userMetadataUpdated) {
    userMetadataDraftRef.value = userMetadataUpdated;
    hasChanges.value = userMetadataDraftRef.value != userMetadata;
  }

  return (hasChanges: hasChanges.value, userMetadataDraftRef: userMetadataDraftRef, update: update);
}
