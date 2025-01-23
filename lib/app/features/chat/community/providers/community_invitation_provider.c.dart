// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_invitation_provider.c.g.dart';

///
/// Returns an invitation to join a community if one exists for the current user
///
@riverpod
FutureOr<JoinCommunityEntity?> communityInvitation(
  Ref ref,
  String communityUUID,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestMessage = RequestMessage(
    filters: [
      RequestFilter(
        kinds: const [JoinCommunityEntity.kind],
        tags: {
          '#h': [communityUUID],
          '#p': [currentPubkey],
        },
      ),
    ],
  );

  final joinCommunityEntity = await ref
      .watch(ionConnectNotifierProvider.notifier)
      .requestEntity<JoinCommunityEntity>(requestMessage);

  if (joinCommunityEntity?.masterPubkey != currentPubkey) {
    return joinCommunityEntity;
  }
  return null;
}
