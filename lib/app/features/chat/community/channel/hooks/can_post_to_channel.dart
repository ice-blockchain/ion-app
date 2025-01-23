import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';

bool canPostToChannel({
  required CommunityDefinitionData? channel,
  required String? currentPubkey,
}) {
  return useMemoized(
    () => [
      ...channel?.admins ?? [],
      ...channel?.moderators ?? [],
      channel?.owner,
    ].contains(currentPubkey),
    [channel?.admins, channel?.moderators, channel?.owner, currentPubkey],
  );
}
