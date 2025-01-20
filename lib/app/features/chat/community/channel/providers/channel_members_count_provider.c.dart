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
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_members_count_provider.c.g.dart';

@riverpod
Future<int> channelMembersCount(Ref ref, String channelUuid) async {
  //TODO: implement
  await ref.watch(ionConnectNotifierProvider.notifier).requestEntity(
        RequestMessage()
          ..addFilter(
            RequestFilter(
              kinds: const [1750],
              ids: [channelUuid],
            ),
          ),
      );
  return 123332;
}
