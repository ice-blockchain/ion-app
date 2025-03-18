// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_followers_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationFollowersSubscription(Ref ref) async {
  return;

//   final currentPubkey = ref.watch(currentPubkeySelectorProvider);
//   final followersRepository = ref.watch(followersRepositoryProvider);
//   final eventParser = ref.watch(eventParserProvider);

//   if (currentPubkey == null) {
//     throw UserMasterPubkeyNotFoundException();
//   }

//   final since = await followersRepository.lastCreatedAt();

//   final requestFilter = RequestFilter(
//     kinds: const [FollowListEntity.kind],
//     tags: {
//       '#p': [currentPubkey],
//     },
//     search: SearchExtensions(
//       [
//         GenericIncludeSearchExtension(
//           forKind: FollowListEntity.kind,
//           includeKind: UserMetadataEntity.kind,
//         ),
//       ],
//     ).toString(),
//     since: since?.subtract(const Duration(seconds: 2)),
//   );
//   final requestMessage = RequestMessage()..addFilter(requestFilter);

//   final events = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
//     requestMessage,
//     subscriptionBuilder: (requestMessage, relay) {
//       final subscription = relay.subscribe(requestMessage);
//       ref.onDispose(() => relay.unsubscribe(subscription.id));
//       return subscription.messages;
//     },
//   );

//   final subscription = events.listen((eventMessage) {
//     followersRepository.save(eventParser.parse(eventMessage));
//   });

//   ref.onDispose(subscription.cancel);
}
