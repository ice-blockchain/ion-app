// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/bool.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/user/model/badges/badge_award.c.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.c.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.c.dart';
import 'package:ion/app/features/user/providers/service_pubkeys_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badges_notifier.c.g.dart';

@riverpod
BadgeAwardEntity? cachedBadgeAward(
  Ref ref,
  String eventId,
  List<String> servicePubkeys,
) {
  final badgeAwardEntityList = servicePubkeys.map((pubkey) {
    final cacheKey = CacheableEntity.cacheKeyBuilder(
      eventReference: ImmutableEventReference(pubkey: pubkey, eventId: eventId),
    );
    return ref.watch(
      ionConnectCacheProvider.select(cacheSelector<BadgeAwardEntity>(cacheKey)),
    );
  }).toList();

  return badgeAwardEntityList.firstOrNull;
}

@riverpod
ProfileBadgesEntity? cachedProfileBadgesData(
  Ref ref,
  String pubkey,
) {
  return ref.watch(
    ionConnectCachedEntityProvider(
      eventReference: ReplaceableEventReference(
        pubkey: pubkey,
        kind: ProfileBadgesEntity.kind,
        dTag: ProfileBadgesEntity.dTag,
      ),
    ),
  ) as ProfileBadgesEntity?;
}

@riverpod
Future<ProfileBadgesData?> profileBadgesData(
  Ref ref,
  String pubkey,
) async {
  final profileBadgesEntity = await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(
        pubkey: pubkey,
        kind: ProfileBadgesEntity.kind,
        dTag: ProfileBadgesEntity.dTag,
      ),
      search: ProfileBadgesSearchExtension().toString(),
    ).future,
  ) as ProfileBadgesEntity?;
  return profileBadgesEntity?.data;
}

@riverpod
Future<bool> isUserVerified(
  Ref ref,
  String pubkey,
) async {
  final profileBadgesData = await ref.watch(
    profileBadgesDataProvider(pubkey).future,
  );
  final pubkeys = await ref.watch(servicePubkeysProvider.future);

  return profileBadgesData?.entries.any((entry) {
        final eventRef = entry.definitionRef;
        final isBadgeAwardValid =
            pubkeys.isEmpty || ref.watch(cachedBadgeAwardProvider(entry.awardId, pubkeys)) != null;
        final isBadgeDefinitionValid = eventRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag &&
            (pubkeys.isEmpty || pubkeys.contains(eventRef.pubkey)) &&
            eventRef.kind == BadgeDefinitionEntity.kind;
        return isBadgeDefinitionValid && isBadgeAwardValid;
      }) ??
      false;
}

@Riverpod(keepAlive: true)
bool isCurrentUserVerified(Ref ref) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return false;
  }

  return ref.watch(isUserVerifiedProvider(currentPubkey)).valueOrNull ?? false;
}

@riverpod
Stream<BadgeAwardEntity> badgeAwardsStream(
  Ref ref,
  String pubkey,
) {
  final authState = ref.watch(authProvider).valueOrNull;
  if (authState == null || !authState.isAuthenticated) {
    return const Stream.empty();
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
  if (currentPubkey == null || !delegationComplete) {
    return const Stream.empty();
  }

  final streamController = StreamController<BadgeAwardEntity>.broadcast();

  final request = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [BadgeAwardEntity.kind],
        tags: {
          '#p': [pubkey],
        },
      ),
    );

  final events = ref.watch(
    ionConnectEventsSubscriptionProvider(
      request,
    ),
  );

  final subscription = events.listen((eventMessage) {
    streamController.add(
      BadgeAwardEntity.fromEventMessage(eventMessage),
    );
  });

  ref.onDispose(() {
    subscription.cancel();
    streamController.close();
  });

  return streamController.stream;
}

@Riverpod(keepAlive: true)
void currentUserBadgesSync(Ref ref) {
  final authState = ref.watch(authProvider).valueOrNull;
  if (authState == null || !authState.isAuthenticated) {
    return;
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
  if (currentPubkey == null || !delegationComplete) {
    return;
  }

  final isVerified = ref.watch(isUserVerifiedProvider(currentPubkey)).valueOrNull;
  if (isVerified == null || isVerified) {
    return;
  }

  late final ProviderSubscription<AsyncValue<BadgeAwardEntity>> sub;
  sub = ref.listen<AsyncValue<BadgeAwardEntity>>(
    badgeAwardsStreamProvider(currentPubkey),
    (previous, next) {
      next.whenData((badgeAwardEntity) async {
        final pubkeys = await ref.watch(servicePubkeysProvider.future);
        final eventRef = badgeAwardEntity.data.badgeDefinitionRef;
        if (eventRef.kind == BadgeDefinitionEntity.kind &&
            eventRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag &&
            (pubkeys.isEmpty || pubkeys.contains(eventRef.pubkey))) {
          final profileBadgesData = await ref.read(
            profileBadgesDataProvider(currentPubkey).future,
          );
          final updatedProfileBadgesData = ProfileBadgesData(
            entries: [
              ...(profileBadgesData?.entries ?? []),
              BadgeEntry(
                definitionRef: badgeAwardEntity.data.badgeDefinitionRef,
                awardId: badgeAwardEntity.id,
              ),
            ],
          );
          await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
            [updatedProfileBadgesData],
          );
          // Unsubscribe after handling the verified badge
          sub.close();
        }
      });
    },
  );
  ref.onDispose(sub.close);
}
