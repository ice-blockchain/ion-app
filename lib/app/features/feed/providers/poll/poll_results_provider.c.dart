// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/feed/data/models/poll/poll_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part directive for codegen
part 'poll_results_provider.c.g.dart';

class PollResults {
  const PollResults({
    required this.voteCounts,
    required this.userVotedOptionIndex,
  });
  final List<int> voteCounts;
  final int? userVotedOptionIndex;
}

@riverpod
PollResults pollResults(
  Ref ref,
  EventReference pollEventReference,
  PollData pollData,
) {
  final entity = ref.watch(
    ionConnectCacheProvider.select(
      cacheSelector<EventCountResultEntity>(
        EventCountResultEntity.cacheKeyBuilder(
          key: pollEventReference.toString(),
          type: EventCountResultType.pollVotes,
        ),
      ),
    ),
  );

  final countsMap = entity?.data.content as Map<String, dynamic>? ?? {};
  final voteCounts = List<int>.generate(
    pollData.options.length,
    (i) => (countsMap['$i'] ?? 0) as int,
  );

  // TODO: Implement userVotedOptionIndex if you want to show which option the user voted for
  return PollResults(
    voteCounts: voteCounts,
    userVotedOptionIndex: null,
  );
}
