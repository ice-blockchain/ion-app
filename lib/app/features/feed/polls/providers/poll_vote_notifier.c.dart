// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/polls/data/models/poll_vote_data.c.dart';
import 'package:ion/app/features/feed/polls/providers/poll_results_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poll_vote_notifier.c.g.dart';

/// Provider for voting on polls
@Riverpod(keepAlive: true)
class PollVoteNotifier extends _$PollVoteNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> vote(EventReference postReference, String optionId) async {
    try {
      final masterPubkey = ref.read(currentPubkeySelectorProvider);
      if (masterPubkey == null) {
        throw Exception('User must be logged in to vote');
      }

      final signer = await ref.read(currentUserIonConnectEventSignerProvider.future);
      if (signer == null) {
        throw Exception('Event signer is not available');
      }

      final pollEvent = await ref.read(
        ionConnectEntityProvider(eventReference: postReference).future,
      );
      if (pollEvent == null) {
        throw Exception('Poll event not loaded');
      }

      final pollEventId = postReference.toString();
      final pollVoteData = PollVoteData(
        pollEventId: pollEventId,
        selectedOptionIndexes: [int.parse(optionId)],
      );

      final voteEvent = await pollVoteData.toEventMessage(
        signer,
        tags: [
          ['b', masterPubkey],
        ],
      );

      final result = await ref.read(ionConnectNotifierProvider.notifier).sendEvent(voteEvent);

      if (result != null) {
        ref
          ..invalidate(ionConnectEntityProvider(eventReference: postReference))
          ..invalidate(userPollVoteProvider(postReference))
          ..invalidate(userVotedOptionIndexProvider(postReference))
          ..invalidate(hasUserVotedProvider(postReference))
          ..invalidate(pollVoteCountsProvider);
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace, message: 'Failed to vote on poll');
      return false;
    }
  }
}
