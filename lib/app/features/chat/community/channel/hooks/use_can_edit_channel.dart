// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.f.dart';

bool useCanEditChannel({
  required CommunityDefinitionEntity? channel,
  required String? currentPubkey,
}) {
  return useMemoized(
    () => [
      ...channel?.data.admins ?? [],
      channel?.ownerPubkey,
    ].contains(currentPubkey),
    [channel?.data.admins, channel?.ownerPubkey, currentPubkey],
  );
}
