// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/badges/badge_award.f.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.f.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.f.dart';
import 'package:ion/app/features/user/model/badges/verified_badge_data.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/service_pubkeys_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badges_notifier.r.g.dart';

@riverpod
BadgeAwardEntity? cachedBadgeAward(
  Ref ref,
  String eventId,
  List<String> servicePubkeys,
) {
  final badgeAwardEntityList = servicePubkeys.map((pubkey) {
    final cacheKey = CacheableEntity.cacheKeyBuilder(
      eventReference: ImmutableEventReference(masterPubkey: pubkey, eventId: eventId),
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
        masterPubkey: pubkey,
        kind: ProfileBadgesEntity.kind,
        dTag: ProfileBadgesEntity.dTag,
      ),
    ),
  ) as ProfileBadgesEntity?;
}

@riverpod
Future<BadgeDefinitionEntity?> badgeDefinitionEntity(
  Ref ref,
  String dTag,
  List<String> servicePubkeys,
) async {
  if (servicePubkeys.isEmpty) {
    return null;
  }

  final badgeDefinitionEntityList = servicePubkeys
      .map((pubkey) {
        final cacheKey = CacheableEntity.cacheKeyBuilder(
          eventReference: ReplaceableEventReference(
            masterPubkey: pubkey,
            kind: BadgeDefinitionEntity.kind,
            dTag: dTag,
          ),
        );
        return ref.watch(
          ionConnectCacheProvider.select(cacheSelector<BadgeDefinitionEntity>(cacheKey)),
        );
      })
      .nonNulls
      .toList();

  if (badgeDefinitionEntityList.isNotEmpty) {
    return badgeDefinitionEntityList.first;
  }

  for (final pubkey in servicePubkeys) {
    final fetchedEntity = await ref.watch(
      ionConnectNetworkEntityProvider(
        eventReference: ReplaceableEventReference(
          masterPubkey: pubkey,
          kind: BadgeDefinitionEntity.kind,
          dTag: dTag,
        ),
        actionSource: const ActionSourceCurrentUser(),
      ).future,
    ) as BadgeDefinitionEntity?;
    if (fetchedEntity != null) {
      return fetchedEntity;
    }
  }

  return null;
}

@riverpod
Future<ProfileBadgesData?> profileBadgesData(
  Ref ref,
  String pubkey,
) async {
  final profileBadgesEntity = await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(
        masterPubkey: pubkey,
        kind: ProfileBadgesEntity.kind,
        dTag: ProfileBadgesEntity.dTag,
      ),
      search: ProfileBadgesSearchExtension().toString(),
    ).future,
  ) as ProfileBadgesEntity?;
  return profileBadgesEntity?.data;
}

@riverpod
bool isValidVerifiedBadgeDefinition(
  Ref ref,
  ReplaceableEventReference badgeRef,
  List<String> servicePubkeys,
) {
  return badgeRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag &&
      (servicePubkeys.isEmpty || servicePubkeys.contains(badgeRef.masterPubkey)) &&
      badgeRef.kind == BadgeDefinitionEntity.kind;
}

@riverpod
bool isValidNicknameProofBadgeDefinition(
  Ref ref,
  ReplaceableEventReference badgeRef,
  List<String> servicePubkeys,
) {
  return badgeRef.dTag.startsWith(BadgeDefinitionEntity.usernameProofOfOwnershipBadgeDTag) &&
      (servicePubkeys.isEmpty || servicePubkeys.contains(badgeRef.masterPubkey)) &&
      badgeRef.kind == BadgeDefinitionEntity.kind;
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
        final isBadgeAwardValid =
            pubkeys.isEmpty || ref.watch(cachedBadgeAwardProvider(entry.awardId, pubkeys)) != null;
        final isBadgeDefinitionValid =
            ref.watch(isValidVerifiedBadgeDefinitionProvider(entry.definitionRef, pubkeys));
        return isBadgeDefinitionValid && isBadgeAwardValid;
      }) ??
      false;
}

@riverpod
Future<bool> isNicknameProven(
  Ref ref,
  String pubkey,
) async {
  final [
    profileBadgesData as ProfileBadgesData?,
    userMetadata as UserMetadataEntity?,
    pubkeys as List<String>
  ] = await Future.wait([
    ref.watch(profileBadgesDataProvider(pubkey).future),
    ref.watch(userMetadataProvider(pubkey).future),
    ref.watch(servicePubkeysProvider.future),
  ]);

  if (userMetadata == null) {
    return false;
  }

  return profileBadgesData?.entries.any((entry) {
        final isBadgeAwardValid =
            pubkeys.isEmpty || ref.watch(cachedBadgeAwardProvider(entry.awardId, pubkeys)) != null;
        final isBadgeDefinitionValid =
            ref.watch(isValidNicknameProofBadgeDefinitionProvider(entry.definitionRef, pubkeys));
        return isBadgeDefinitionValid &&
            isBadgeAwardValid &&
            entry.definitionRef.dTag.endsWith('~${userMetadata.data.name}');
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
Future<VerifiedBadgeEntities?> currentUserVerifiedBadgeData(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }

  // Fetch service pubkeys
  final servicePubkeys = await ref.watch(servicePubkeysProvider.future);

  // 1. Load profile badges data from cache only
  final profileEntity = ref.watch(
    ionConnectCachedEntityProvider(
      eventReference: ReplaceableEventReference(
        masterPubkey: currentPubkey,
        kind: ProfileBadgesEntity.kind,
        dTag: ProfileBadgesEntity.dTag,
      ),
    ),
  ) as ProfileBadgesEntity?;
  final profileData = profileEntity?.data;

  // 2. Find the 'verified' badge award entry
  final verifiedEntry = profileData?.entries.firstWhereOrNull(
    (entry) => entry.definitionRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag,
  );

  // Load the corresponding BadgeAwardEntity from cache only
  final awardEntity = verifiedEntry != null
      ? ref.watch(cachedBadgeAwardProvider(verifiedEntry.awardId, servicePubkeys))
      : null;

  // 3. Load the corresponding BadgeDefinitionEntity with 'verified' dTag from cache only
  final definitionEntity = verifiedEntry != null
      ? ref.watch(
          ionConnectCachedEntityProvider(
            eventReference: ReplaceableEventReference(
              masterPubkey: verifiedEntry.definitionRef.masterPubkey,
              kind: BadgeDefinitionEntity.kind,
              dTag: BadgeDefinitionEntity.verifiedBadgeDTag,
            ),
          ),
        ) as BadgeDefinitionEntity?
      : null;

  return VerifiedBadgeEntities(
    profileEntity: profileEntity,
    awardEntity: awardEntity,
    definitionEntity: definitionEntity,
  );
}

@riverpod
Future<ProfileBadgesData> updatedProfileBadges(Ref ref, BadgeEntry newEntry, String pubkey) async {
  final profileData = await ref.watch(
    profileBadgesDataProvider(pubkey).future,
  );
  final existing = profileData?.entries ?? [];
  final newDTag = newEntry.definitionRef.dTag;

  // Filter out any entry with the same dTag
  final filtered = existing.where((e) => e.definitionRef.dTag != newDTag).toList();

  return ProfileBadgesData(
    entries: [...filtered, newEntry],
  );
}

@riverpod
Future<ProfileBadgesData?> updateProfileBadgesWithUsernameProofs(
  Ref ref,
  List<EventMessage> events,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) return null;

  final awardEntity = events
      .where((event) => event.kind == BadgeAwardEntity.kind)
      .map(BadgeAwardEntity.fromEventMessage)
      .nonNulls
      .where(
        (entity) => entity.data.badgeDefinitionRef.dTag
            .startsWith(BadgeDefinitionEntity.usernameProofOfOwnershipBadgeDTag),
      )
      .firstOrNull;
  if (awardEntity == null) {
    return null;
  }

  return ref.read(
    updatedProfileBadgesProvider(
      BadgeEntry(
        definitionRef: awardEntity.data.badgeDefinitionRef,
        awardId: awardEntity.id,
      ),
      currentPubkey,
    ).future,
  );
}

@riverpod
({bool isVerified, bool isNicknameProven}) cachedUserBadgeVerificationState(
  Ref ref,
  String pubkey,
) {
  final cachedProfileBadges = ref.watch(cachedProfileBadgesDataProvider(pubkey));
  final cachedUserMetadata = ref.watch(cachedUserMetadataProvider(pubkey));

  final servicePubkeys = ref.watch(servicePubkeysProvider).valueOrNull ?? <String>[];

  var isVerified = false;
  if (cachedProfileBadges?.data != null) {
    isVerified = cachedProfileBadges!.data.entries.any((entry) {
      final isBadgeAwardValid = servicePubkeys.isEmpty ||
          ref.watch(cachedBadgeAwardProvider(entry.awardId, servicePubkeys)) != null;
      final isBadgeDefinitionValid =
          ref.watch(isValidVerifiedBadgeDefinitionProvider(entry.definitionRef, servicePubkeys));
      return isBadgeDefinitionValid && isBadgeAwardValid;
    });
  }

  var isNicknameProven = false;
  if (cachedUserMetadata?.data != null && cachedProfileBadges?.data != null) {
    isNicknameProven = cachedProfileBadges!.data.entries.any((entry) {
      final isBadgeAwardValid = servicePubkeys.isEmpty ||
          ref.watch(cachedBadgeAwardProvider(entry.awardId, servicePubkeys)) != null;
      final isBadgeDefinitionValid = ref
          .watch(isValidNicknameProofBadgeDefinitionProvider(entry.definitionRef, servicePubkeys));
      return isBadgeDefinitionValid &&
          isBadgeAwardValid &&
          entry.definitionRef.dTag.endsWith('~${cachedUserMetadata!.data.name}');
    });
  }

  return (isVerified: isVerified, isNicknameProven: isNicknameProven);
}
