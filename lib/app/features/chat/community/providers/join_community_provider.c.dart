// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/providers/community_invitation_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'join_community_provider.c.g.dart';

@riverpod
class JoinCommunityNotifier extends _$JoinCommunityNotifier {
  @override
  FutureOr<void> build() {}

  FutureOr<void> joinCommunity(String communityUUUID) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final pubkey = ref.read(currentPubkeySelectorProvider);

      if (pubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final community = await ref.read(communityMetadataProvider(communityUUUID).future);

      var joinData = CommunityJoinData(
        uuid: communityUUUID,
        pubkey: pubkey,
      );

      if (!community.data.isOpen && pubkey != community.ownerPubkey) {
        final invitationEvent = await ref.read(communityInvitationProvider(communityUUUID).future);

        if (invitationEvent == null) {
          throw CommunityInvitationNotFoundException();
        }

        final invitation = CommunityJoinEntity.fromEventMessage(invitationEvent);

        if (invitation.data.expiration != null &&
            invitation.data.expiration!.toDateTime.isBefore(DateTime.now())) {
          throw CommunityInvitationExpiredException();
        }
        joinData = joinData.copyWith(auth: jsonEncode(invitationEvent.toJson().last));
      }

      final result = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData(joinData, actionSource: ActionSourceUser(community.ownerPubkey));

      if (result == null) {
        throw FailedToJoinCommunityException();
      }

      ref.invalidate(communityJoinRequestsProvider);
    });
  }
}
