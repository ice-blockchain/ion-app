// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_invitation_provider.r.g.dart';

///
/// Returns an invitation to join a community if one exists for the current user
///
@riverpod
FutureOr<EventMessage?> communityInvitation(
  Ref ref,
  String communityUUID,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestMessage = RequestMessage(
    filters: [
      RequestFilter(
        kinds: const [CommunityJoinEntity.kind],
        tags: {
          '#h': [communityUUID],
          '#p': [currentPubkey],
        },
      ),
    ],
  );

  final joinCommunityEntity =
      await ref.watch(ionConnectNotifierProvider.notifier).requestEvent(requestMessage);

  joinCommunityEntity?.toString();

  if (joinCommunityEntity?.masterPubkey != currentPubkey) {
    return joinCommunityEntity;
  }
  return null;
}
