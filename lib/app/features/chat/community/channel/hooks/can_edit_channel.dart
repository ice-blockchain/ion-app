import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';

bool canEditChannel({
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
