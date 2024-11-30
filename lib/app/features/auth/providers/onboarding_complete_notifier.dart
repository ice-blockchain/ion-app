// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/follow_list.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:ion/app/features/user/model/interests.dart';
import 'package:ion/app/features/user/model/user_delegation.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
import 'package:ion/app/services/storage/user_preferences_service.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_notifier.g.dart';

@riverpod
class OnboardingCompleteNotifier extends _$OnboardingCompleteNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> finish() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final (relayUrls, nostrKeyStore) =
            await (_assignUserRelays(), _generateNostrKeyStore()).wait;

        final userRelaysEvent = _buildUserRelays(relayUrls: relayUrls);

        // Add user relays to cache first because other actions rely on it
        ref
            .read(nostrCacheProvider.notifier)
            .cache(UserRelaysEntity.fromEventMessage(userRelaysEvent));

        final userDelegationEvent = await _buildUserDelegation(keyStore: nostrKeyStore);

        final userMetadataEvent = _buildUserMetadata();

        final (:interestSetEvent, :interestsEvent) = _buildUserLanguages();

        final followListEvent = _buildFollowList();

        final avatarFileMetadataEvent = _buildAvatarFileMetadataEvent();

        await ref.read(nostrNotifierProvider.notifier).sendEvents([
          // Delegation should be first
          userDelegationEvent,
          followListEvent,
          interestSetEvent,
          interestsEvent,
          userRelaysEvent,
          userMetadataEvent,
          if (avatarFileMetadataEvent != null) avatarFileMetadataEvent,
        ]);

        <CacheableEntity>[
          FollowListEntity.fromEventMessage(followListEvent),
          InterestSetEntity.fromEventMessage(interestSetEvent),
          InterestsEntity.fromEventMessage(interestsEvent),
          UserMetadataEntity.fromEventMessage(userMetadataEvent),
          UserDelegationEntity.fromEventMessage(userDelegationEvent),
        ].forEach(ref.read(nostrCacheProvider.notifier).cache);

        ref.invalidate(onboardingDataProvider);
      },
    );
  }

  Future<List<String>> _assignUserRelays() async {
    final UserDetails(:ionConnectRelays) = (await ref.read(currentUserIdentityProvider.future))!;
    if (ionConnectRelays != null && ionConnectRelays.isNotEmpty) {
      return ionConnectRelays;
    }
    final followees = ref.read(onboardingDataProvider).followees;

    final userRelays =
        await ref.read(currentUserIdentityProvider.notifier).assignUserRelays(followees: followees);

    if (followees != null) {
      // Persisting followees so that in case of finish onboarding retry we could create FollowList event out of it
      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
      await ref
          .read(userPreferencesServiceProvider(identityKeyName: identityKeyName!))
          .setValue(followeesListPersistanceKey, followees);
    }

    return userRelays;
  }

  Future<KeyStore> _generateNostrKeyStore() async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final nostrKeyStore = await ref.read(currentUserNostrKeyStoreProvider.future) ??
        await ref.read(nostrKeyStoreProvider(currentIdentityKeyName).notifier).generate();
    return nostrKeyStore;
  }

  EventMessage _buildUserRelays({required List<String> relayUrls}) {
    final userRelays = UserRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    return ref.read(nostrNotifierProvider.notifier).sign(userRelays);
  }

  EventMessage _buildUserMetadata() {
    final OnboardingState(:name, :displayName, :avatarMediaAttachment) =
        ref.read(onboardingDataProvider);

    if (name == null) {
      throw Exception('Failed to create user metadata, name is empty');
    }

    if (displayName == null) {
      throw Exception('Failed to create user metadata, display name is empty');
    }

    final userMetadata = UserMetadata(
      name: name,
      displayName: displayName,
      picture: avatarMediaAttachment?.url,
      media:
          avatarMediaAttachment != null ? {avatarMediaAttachment.url: avatarMediaAttachment} : {},
    );

    return ref.read(nostrNotifierProvider.notifier).sign(userMetadata);
  }

  ({EventMessage interestSetEvent, EventMessage interestsEvent}) _buildUserLanguages() {
    final OnboardingState(:languages) = ref.read(onboardingDataProvider);

    if (languages == null || languages.isEmpty) {
      throw Exception('Failed to create user interests, languages is null or empty');
    }

    final interestSetData = InterestSetData(
      type: InterestSetType.languages,
      hashtags: languages,
    );

    final interestSetEvent = ref.read(nostrNotifierProvider.notifier).sign(interestSetData);

    final interestsData = InterestsData(
      hashtags: [],
      interestSetRefs: [interestSetData.toReplaceableEventReference(interestSetEvent.pubkey)],
    );

    final interestsEvent = ref.read(nostrNotifierProvider.notifier).sign(interestsData);

    return (interestSetEvent: interestSetEvent, interestsEvent: interestsEvent);
  }

  Future<EventMessage> _buildUserDelegation({
    required KeyStore keyStore,
  }) async {
    final userDelegationData = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationDataWith(pubkey: keyStore.publicKey);

    return ref
        .read(userDelegationManagerProvider.notifier)
        .buildDelegationEventFrom(userDelegationData);
  }

  EventMessage _buildFollowList() {
    final onboardingData = ref.read(onboardingDataProvider);

    var followees = onboardingData.followees;

    if (followees == null) {
      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
      final service = ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName!));
      followees = service.getValue<List<String>>(followeesListPersistanceKey);
    }

    final followListData = FollowListData(
      list: followees == null ? [] : followees.map((pubkey) => Followee(pubkey: pubkey)).toList(),
    );

    return ref.read(nostrNotifierProvider.notifier).sign(followListData);
  }

  static const String followeesListPersistanceKey = 'OnboardingCompleteNotifier:followees';

  EventMessage? _buildAvatarFileMetadataEvent() {
    final fileMetadata = ref.read(onboardingDataProvider).avatarFileMetadata;

    if (fileMetadata == null) return null;

    return ref.read(nostrNotifierProvider.notifier).sign(fileMetadata);
  }
}
