// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
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
    since: DateTime.now().subtract(const Duration(seconds: 2)),
  );

  await ref.watch(entitiesSyncerNotifierProvider('notifications-followers').notifier).syncEntities(
    requestFilters: [requestFilter],
    saveCallback: (entity) {
      if (entity is FollowListEntity &&
          entity.data.list.isNotEmpty &&
          entity.data.list.last.pubkey == currentPubkey) {
        followersRepository.save(entity);
      }
    },
    maxCreatedAtBuilder: followersRepository.lastCreatedAt,
    minCreatedAtBuilder: (since) => followersRepository.firstCreatedAt(after: since),
  );

  final requestMessage = RequestMessage()..addFilter(requestFilter);

  final entities = ref.watch(ionConnectEntitiesSubscriptionProvider(requestMessage));

  final subscription = entities
      .where(
        (entity) =>
            entity is FollowListEntity &&
            entity.data.list.isNotEmpty &&
            entity.data.list.last.pubkey == currentPubkey,
      )
      .listen(followersRepository.save);

  ref.onDispose(subscription.cancel);
}
