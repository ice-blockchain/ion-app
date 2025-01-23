import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/join_community_data.c.dart';
import 'package:ion/app/features/chat/community/providers/community_invitation_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'join_community_provider.c.g.dart';

@riverpod
FutureOr<void> joinCommunity(
  Ref ref,
  String communityUUUID,
) async {
  final pubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final invitation = await ref.watch(communityInvitationProvider(communityUUUID).future);

  if (invitation != null) {
    if (invitation.data.expiration != null &&
        invitation.data.expiration!.isBefore(DateTime.now())) {
      throw CommunityInvitationExpiredException();
    }
  }

  final community = await ref.watch(communityMetadataProvider(communityUUUID).future);

  var joinData = JoinCommunityData(
    uuid: communityUUUID,
    pubkey: pubkey,
  );

  if (!community.isOpen) {
    if (invitation == null) {
      throw CommunityInvitationNotFoundException();
    }
    joinData = joinData.copyWith(auth: jsonEncode(invitation));
  }

  final result = await ref
      .read(ionConnectNotifierProvider.notifier)
      .sendEntityData(joinData, actionSource: ActionSourceUser(community.owner));

  if (result == null) {
    throw FailedToSendInvitationException();
  }

  ref.invalidate(communityJoinRequestsProvider);
}
