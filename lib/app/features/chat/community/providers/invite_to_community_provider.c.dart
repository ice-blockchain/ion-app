// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invite_to_community_provider.c.g.dart';

@riverpod
FutureOr<void> inviteToCommunity(
  Ref ref,
  String communityUUUID,
  String invitedPubkey,
) async {
  final expiration = DateTime.now().add(const Duration(days: 1));

  final invitation = CommunityJoinData(
    uuid: communityUUUID,
    pubkey: invitedPubkey,
    expiration: expiration,
  );

  final result = await ref
      .read(ionConnectNotifierProvider.notifier)
      .sendEntityData(invitation, actionSource: ActionSourceUser(invitedPubkey));

  if (result == null) {
    throw FailedToSendInvitationException();
  }
}
