// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/community_join_requests_state.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_join_requests_provider.c.g.dart';

///
/// Provides join requests for the current user.
///
/// The state is exposed through [CommunityJoinRequestsState] which contains two lists:
/// - accepted: List of [CommunityJoinEntity] that have been accepted
/// - waitingApproval: List of [CommunityJoinEntity] pending approval
///
@riverpod
FutureOr<CommunityJoinRequestsState> communityJoinRequests(Ref ref) async {
  final hideCommunity =
      ref.watch(featureFlagsProvider.notifier).get(HideCommunityFeatureFlag.hideCommunity);

  if (hideCommunity) {
    return const CommunityJoinRequestsState(
      accepted: [],
      waitingApproval: [],
    );
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestMessage = RequestMessage(
    filters: [
      RequestFilter(
        kinds: const [CommunityJoinEntity.kind],
        tags: {
          '#p': [currentPubkey],
        },
      ),
    ],
  );

  final eventsStream = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(requestMessage);

  final accepted = <CommunityJoinEntity>[];
  final acceptedEvents = <EventMessage>[];
  final waitingApproval = <CommunityJoinEntity>[];

  await for (final event in eventsStream) {
    final entity = CommunityJoinEntity.fromEventMessage(event);

    if (entity.masterPubkey == currentPubkey) {
      accepted.add(entity);
      acceptedEvents.add(event);
    } else {
      if (entity.data.expiration != null && entity.data.expiration!.isAfter(DateTime.now())) {
        waitingApproval.add(entity);
      }
    }
  }

  await ref.watch(conversationDaoProvider).add(acceptedEvents);

  return CommunityJoinRequestsState(accepted: accepted, waitingApproval: waitingApproval);
}
