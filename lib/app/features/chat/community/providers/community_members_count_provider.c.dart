// SPDX-License-Identifier: ice License 1.0

// {
//     "kind": 5400,
//     "content": "[{\"kinds\":[1750], \"#h\":[\"<community UUIDv7>\"]}]",
//     "tags": [
//       ["param", "group", "p"],
//       ["param", "relay", "ws://foo.com -- this is the url of the relay that you send this event to"]
//     ],
//     ... + the rest of the event fields defined in NIP-01
// }

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_members_count_provider.c.g.dart';

@riverpod
Future<int> communityMembersCount(Ref ref, String communityUuid) async {
  //TODO: implement

  final communityOwner = (await ref.watch(communityMetadataProvider(communityUuid).future)).owner;

  final request = EventCountRequestData(
    filters: [
      RequestFilter(
        kinds: const [1750],
        tags: {
          '#h': [communityUuid],
        },
      ),
    ],
    params: const EventCountRequestParams(group: 'p'),
  );
  final response = await ref
      .watch(ionConnectNotifierProvider.notifier)
      .requestCount(request, actionSource: ActionSourceUser(communityOwner));

  return response.data.content as int;
}
