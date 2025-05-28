// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
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
  FutureOr<void> build() {
    // No state needed
  }

  /// Vote for a poll option using kind 7 reaction format
  Future<bool> vote(EventReference postReference, String optionId) async {
    try {
      // Ensure user is authenticated
      final pubkey = ref.read(currentPubkeySelectorProvider);
      if (pubkey == null) {
        throw Exception('User must be logged in to vote');
      }

      final signer = await ref.read(currentUserIonConnectEventSignerProvider.future);
      if (signer == null) {
        throw Exception('Event signer is not available');
      }

      // Create reaction event with poll_vote tag
      final reactionEvent = await EventMessage.fromData(
        signer: signer,
        kind: 7, // Reaction kind
        content: '+', // Standard reaction content
        tags: [
          postReference.toTag(), // Reference to the post containing poll
          ['poll_vote', optionId], // Vote for the specific option
          ['p', postReference.pubkey], // Publisher reference
        ],
      );

      // Send the vote event
      final result = await ref.read(ionConnectNotifierProvider.notifier).sendEvent(reactionEvent);

      if (result != null) {
        // Refresh post entity to reflect updated vote count
        ref.invalidate(ionConnectEntityProvider(eventReference: postReference));
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace, message: 'Failed to vote on poll');
      return false;
    }
  }
}
