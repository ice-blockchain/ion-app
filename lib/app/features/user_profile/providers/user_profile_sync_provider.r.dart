// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/badges/badge_award.f.dart';
import 'package:ion/app/features/user/model/badges/badge_definition.f.dart';
import 'package:ion/app/features/user/model/badges/profile_badges.f.dart';
import 'package:ion/app/features/user/model/user_delegation.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/service_pubkeys_provider.r.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/features/user_profile/database/dao/user_badge_info_dao.m.dart';
import 'package:ion/app/features/user_profile/database/dao/user_delegation_dao.m.dart';
import 'package:ion/app/features/user_profile/database/dao/user_metadata_dao.m.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_sync_provider.r.g.dart';

@riverpod
class UserProfileSync extends _$UserProfileSync {
  static const String localStorageKey = 'user_profile_last_sync';

  @override
  Future<void> build() async {
    final keepAlive = ref.keepAlive();
    onLogout(ref, keepAlive.close);

    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) return;

    final delegationComplete = await ref.watch(delegationCompleteProvider.future);
    if (!delegationComplete) return;
  }

  Future<void> syncUserProfile({
    bool forceSync = false,
    Set<String> masterPubkeys = const {},
  }) async {
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);

    if (masterPubkey == null) throw UserMasterPubkeyNotFoundException();

    final userMetadataDao = ref.watch(userMetadataDaoProvider);
    final userDelegationDao = ref.watch(userDelegationDaoProvider);
    final userBadgesDao = ref.watch(userBadgeInfoDaoProvider);

    final existingMasterPubkeys = await userMetadataDao.getExistingMasterPubkeys();

    final masterPubkeysDifference = masterPubkeys.difference(existingMasterPubkeys);

    final masterPubkeysToSync = Set<String>.from(existingMasterPubkeys)..addAll(masterPubkeys);

    final syncWindow =
        ref.read(envProvider.notifier).get<int>(EnvVariable.USER_METADATA_SYNC_MINUTES);

    final localStorage = await ref.watch(localStorageAsyncProvider.future);

    final lastSyncTime = DateTime.tryParse(localStorage.getString(localStorageKey) ?? '');

    if (forceSync ||
        lastSyncTime == null ||
        masterPubkeysDifference.isNotEmpty ||
        lastSyncTime.isBefore(DateTime.now().subtract(Duration(minutes: syncWindow)))) {
      final usersMetadata = await _fetchUsersMetadata(ref: ref, masterPubkeys: masterPubkeysToSync);
      final usersDelegation =
          await _fetchUsersDelegation(ref: ref, masterPubkeys: masterPubkeysToSync);
      final profileBadges = await _fetchProfileBadges(ref: ref, masterPubkeys: masterPubkeysToSync);
      final badgeDefinitions = await _fetchBadgeDefinitions(ref: ref, profileBadges: profileBadges);
      final badgeAwards = await _fetchBadgeAwards(ref: ref, profileBadges: profileBadges);

      if (usersMetadata.isEmpty || usersDelegation.isEmpty) return;

      // If relay returned null for a master pubkey, we should remove existing metadata
      final deletedUsers =
          masterPubkeysToSync.difference(usersMetadata.map((e) => e.masterPubkey).toSet());

      await userMetadataDao.insertAll(usersMetadata);
      await userDelegationDao.insertAll(usersDelegation);
      await userBadgesDao.insertAllProfileBadges(profileBadges);
      await userBadgesDao.insertAllBadgeDefinitions(badgeDefinitions);
      await userBadgesDao.insertAllBadgeAwards(badgeAwards);

      await userMetadataDao.deleteMetadata(deletedUsers.toList());
      await userDelegationDao.deleteDelegation(deletedUsers.toList());

      await localStorage.setString(localStorageKey, DateTime.now().toIso8601String());
    }
  }

  Future<List<UserMetadataEntity>> _fetchUsersMetadata({
    required Ref ref,
    required Set<String> masterPubkeys,
  }) async {
    final usersMetadata = <UserMetadataEntity>[];

    if (masterPubkeys.isEmpty) return usersMetadata;

    for (final masterPubkey in masterPubkeys) {
      try {
        final metadata = await ref.read(userMetadataProvider(masterPubkey, cache: false).future);
        if (metadata != null) {
          usersMetadata.add(metadata);
        }
      } catch (e) {
        Logger.error('Failed to fetch user metadata for master pubkey: $masterPubkey');
      }
    }

    return usersMetadata;
  }

  Future<List<UserDelegationEntity>> _fetchUsersDelegation({
    required Ref ref,
    required Set<String> masterPubkeys,
  }) async {
    final usersDelegation = <UserDelegationEntity>[];

    if (masterPubkeys.isEmpty) return usersDelegation;

    for (final masterPubkey in masterPubkeys) {
      try {
        final index = masterPubkeys.toList().indexOf(masterPubkey);
        if (index == 1) {
          throw Exception();
        }
        final delegation =
            await ref.read(userDelegationProvider(masterPubkey, cache: false).future);
        if (delegation != null) {
          usersDelegation.add(delegation);
        }
      } catch (e) {
        Logger.error('Failed to fetch user delegation for master pubkey: $masterPubkey');
      }
    }

    return usersDelegation;
  }

  Future<List<ProfileBadgesEntity>> _fetchProfileBadges({
    required Ref ref,
    required Set<String> masterPubkeys,
  }) async {
    final profileBadges = <ProfileBadgesEntity>[];

    if (masterPubkeys.isEmpty) return profileBadges;

    for (final masterPubkey in masterPubkeys) {
      try {
        final profileBadge = await ref.watch(
          ionConnectNetworkEntityProvider(
            eventReference: ReplaceableEventReference(
              masterPubkey: masterPubkey,
              kind: ProfileBadgesEntity.kind,
              dTag: ProfileBadgesEntity.dTag,
            ),
            search: ProfileBadgesSearchExtension().toString(),
          ).future,
        ) as ProfileBadgesEntity?;

        if (profileBadge != null) {
          profileBadges.add(profileBadge);
        }
      } catch (e) {
        Logger.error('Failed to fetch profile badges for master pubkey: $masterPubkey');
      }
    }

    return profileBadges;
  }

  Future<List<BadgeDefinitionEntity>> _fetchBadgeDefinitions({
    required Ref ref,
    required List<ProfileBadgesEntity> profileBadges,
  }) async {
    final badgeDefinitions = <BadgeDefinitionEntity>[];

    final servicePubkeys = await ref.watch(servicePubkeysProvider.future);

    if (profileBadges.isEmpty) return badgeDefinitions;

    for (final profileBadge in profileBadges) {
      final verifiedEntry = profileBadge.data.entries.firstWhereOrNull(
        (entry) => entry.definitionRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag,
      );

      final proofOfNameEntry = profileBadge.data.entries.firstWhereOrNull(
        (entry) => entry.definitionRef.dTag
            .startsWith(BadgeDefinitionEntity.usernameProofOfOwnershipBadgeDTag),
      );
      for (final servicePubkey in servicePubkeys) {
        try {
          if (verifiedEntry != null) {
            final verifiedBadgeDefinition = await ref.watch(
              ionConnectNetworkEntityProvider(
                eventReference: ReplaceableEventReference(
                  masterPubkey: servicePubkey,
                  kind: BadgeDefinitionEntity.kind,
                  dTag: verifiedEntry.definitionRef.dTag,
                ),
                actionSource: const ActionSourceCurrentUser(),
              ).future,
            ) as BadgeDefinitionEntity?;

            if (verifiedBadgeDefinition != null) {
              badgeDefinitions.add(verifiedBadgeDefinition);
            }
          }
        } catch (e) {
          Logger.error(
            'Failed to fetch verified badge definition for service pubkey: $servicePubkey',
          );
        }

        try {
          if (proofOfNameEntry != null) {
            final proofOfNameBadgeDefinition = await ref.watch(
              ionConnectNetworkEntityProvider(
                eventReference: ReplaceableEventReference(
                  kind: BadgeDefinitionEntity.kind,
                  dTag: proofOfNameEntry.definitionRef.dTag,
                  masterPubkey: proofOfNameEntry.definitionRef.masterPubkey,
                ),
                actionSource: const ActionSourceCurrentUser(),
              ).future,
            ) as BadgeDefinitionEntity?;

            if (proofOfNameBadgeDefinition != null) {
              badgeDefinitions.add(proofOfNameBadgeDefinition);
            }
          }
        } catch (e) {
          Logger.error(
            'Failed to fetch proof of name badge definition for service pubkey: $servicePubkey',
          );
        }
      }
    }

    return badgeDefinitions;
  }

  Future<List<BadgeAwardEntity>> _fetchBadgeAwards({
    required Ref ref,
    required List<ProfileBadgesEntity> profileBadges,
  }) async {
    final badgeAwards = <BadgeAwardEntity>[];

    final servicePubkeys = await ref.watch(servicePubkeysProvider.future);

    if (profileBadges.isEmpty) return badgeAwards;

    for (final profileBadge in profileBadges) {
      final verifiedEntry = profileBadge.data.entries.firstWhereOrNull(
        (entry) => entry.definitionRef.dTag == BadgeDefinitionEntity.verifiedBadgeDTag,
      );

      final proofOfNameEntry = profileBadge.data.entries.firstWhereOrNull(
        (entry) => entry.definitionRef.dTag
            .startsWith(BadgeDefinitionEntity.usernameProofOfOwnershipBadgeDTag),
      );

      for (final servicePubkey in servicePubkeys) {
        try {
          if (verifiedEntry != null) {
            final verifiedBadgeAward = await ref.watch(
              ionConnectNetworkEntityProvider(
                eventReference: ImmutableEventReference(
                  masterPubkey: servicePubkey,
                  eventId: verifiedEntry.awardId,
                ),
                actionSource: const ActionSourceCurrentUser(),
              ).future,
            ) as BadgeAwardEntity?;

            if (verifiedBadgeAward != null) {
              badgeAwards.add(verifiedBadgeAward);
            }
          }
        } catch (e) {
          Logger.error(
            'Failed to fetch verified badge award for service pubkey: $servicePubkey',
          );
        }

        try {
          if (proofOfNameEntry != null) {
            final proofOfNameBadgeAward = await ref.watch(
              ionConnectNetworkEntityProvider(
                eventReference: ImmutableEventReference(
                  masterPubkey: servicePubkey,
                  eventId: proofOfNameEntry.awardId,
                ),
                actionSource: const ActionSourceCurrentUser(),
              ).future,
            ) as BadgeAwardEntity?;

            if (proofOfNameBadgeAward != null) {
              badgeAwards.add(proofOfNameBadgeAward);
            }
          }
        } catch (e) {
          Logger.error(
            'Failed to fetch proof of name badge award for service pubkey: $servicePubkey',
          );
        }
      }
    }

    return badgeAwards;
  }
}
