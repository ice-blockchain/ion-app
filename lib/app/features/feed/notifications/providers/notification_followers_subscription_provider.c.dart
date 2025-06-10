// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/event_syncer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_followers_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationFollowersSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final followersRepository = ref.watch(followersRepositoryProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final requestFilter = RequestFilter(
    kinds: const [FollowListEntity.kind],
    tags: {
      '#p': [currentPubkey],
    },
    search: SearchExtensions(
      [
        GenericIncludeSearchExtension(
          forKind: FollowListEntity.kind,
          includeKind: UserMetadataEntity.kind,
        ),
      ],
    ).toString(),
  );

  bool isCurrentUserLastAdded(IonConnectEntity entity) =>
      entity is FollowListEntity &&
      entity.data.list.isNotEmpty &&
      entity.data.list.last.pubkey == currentPubkey;

  final lastCreatedAt = await followersRepository.lastCreatedAt();

  final latestSyncedEventTimestamp = await ref.watch(eventSyncerServiceProvider).syncEvents(
    requestFilters: [requestFilter],
    sinceDateMicroseconds: lastCreatedAt?.microsecondsSinceEpoch,
    saveCallback: (eventMessage) {
      final parser = ref.read(eventParserProvider);
      final entity = parser.parse(eventMessage);

      if (isCurrentUserLastAdded(entity)) {
        followersRepository.save(entity);
      }
    },
  );

  final requestMessage = RequestMessage()
    ..addFilter(requestFilter.copyWith(since: () => latestSyncedEventTimestamp));

  final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

  final subscription = entities.where(isCurrentUserLastAdded).listen(followersRepository.save);

  ref.onDispose(subscription.cancel);
}
