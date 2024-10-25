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

        final (:userRelays, :userRelaysEvent) =
            _buildUserRelays(keyStore: nostrKeyStore, relayUrls: relayUrls);

        // Add user relays to cache first because other actions rely on it
        ref.read(nostrCacheProvider.notifier).cache(userRelays);

        final (:userDelegation, :userDelegationEvent) =
            await _buildUserDelegation(keyStore: nostrKeyStore);

        final (:userMetadata, :userMetadataEvent) = _buildUserMetadata(keyStore: nostrKeyStore);

        final (:interestSet, :interests, :interestSetEvent, :interestsEvent) =
            _buildUserLanguages(keyStore: nostrKeyStore);

        final (:followList, :followListEvent) = _buildFollowList(keyStore: nostrKeyStore);

        final avatarFileMetadataEvent = _buildAvatarFileMetadataEvent(keyStore: nostrKeyStore);

        await ref.read(nostrNotifierProvider.notifier).send([
          //TODO:uncomment when switched to our relays
          // damus returns "rate-limited: you are noting too much"
          // followListEvent,
          // interestSetEvent,
          // interestsEvent,
          if (avatarFileMetadataEvent != null) avatarFileMetadataEvent,
          userRelaysEvent,
          userMetadataEvent,
          userDelegationEvent,
        ]);

        [followList, interestSet, interests, userMetadata, userDelegation]
            .forEach(ref.read(nostrCacheProvider.notifier).cache);

        ref.invalidate(onboardingDataProvider);
      },
    );
  }

  Future<List<String>> _assignUserRelays() async {
    final userIdentity = (await ref.read(currentUserIdentityProvider.future))!;
    if (userIdentity.ionConnectRelays.isNotEmpty) {
      return userIdentity.ionConnectRelays;
    }
    final followees = ref.read(onboardingDataProvider).followees;
    if (followees == null || followees.isEmpty) {
      throw Exception('Failed to assign user relays, follow list is null or empty');
    }

    final userRelays =
        await ref.read(currentUserIdentityProvider.notifier).assignUserRelays(followees: followees);

    // Persisting followees so that in case of finish onboarding retry we could create FollowList event out of it
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    await ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName!))
        .setValue(followeesListPersistanceKey, followees);

    return userRelays;
  }

  Future<KeyStore> _generateNostrKeyStore() async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final nostrKeyStore = await ref.read(currentUserNostrKeyStoreProvider.future) ??
        await ref.read(nostrKeyStoreProvider(currentIdentityKeyName).notifier).generate();
    return nostrKeyStore;
  }

  ({UserRelays userRelays, EventMessage userRelaysEvent}) _buildUserRelays({
    required KeyStore keyStore,
    required List<String> relayUrls,
  }) {
    final userRelays = UserRelays(
      pubkey: keyStore.publicKey,
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final userRelaysEvent = userRelays.toEventMessage(keyStore);

    return (userRelays: userRelays, userRelaysEvent: userRelaysEvent);
  }

  ({UserMetadata userMetadata, EventMessage userMetadataEvent}) _buildUserMetadata({
    required KeyStore keyStore,
  }) {
    final OnboardingState(:name, :displayName, :avatarMediaAttachment) =
        ref.read(onboardingDataProvider);

    if (name == null) {
      throw Exception('Failed to create user metadata, name is empty');
    }

    if (displayName == null) {
      throw Exception('Failed to create user metadata, display name is empty');
    }

    final userMetadata = UserMetadata(
      pubkey: keyStore.publicKey,
      name: name,
      displayName: displayName,
      picture: avatarMediaAttachment?.url,
      media:
          avatarMediaAttachment != null ? {avatarMediaAttachment.url: avatarMediaAttachment} : {},
    );

    final userMetadataEvent = userMetadata.toEventMessage(keyStore);

    return (userMetadata: userMetadata, userMetadataEvent: userMetadataEvent);
  }

  ({
    InterestSet interestSet,
    Interests interests,
    EventMessage interestSetEvent,
    EventMessage interestsEvent
  }) _buildUserLanguages({required KeyStore keyStore}) {
    final OnboardingState(:languages) = ref.read(onboardingDataProvider);

    if (languages == null || languages.isEmpty) {
      throw Exception('Failed to create user interests, languages is null or empty');
    }

    final interestSet = InterestSet(
      pubkey: keyStore.publicKey,
      type: InterestSetType.languages,
      hashtags: languages,
    );

    final interestSetEvent = interestSet.toEventMessage(keyStore);

    final interests = Interests(
      pubkey: keyStore.publicKey,
      hashtags: [],
      interestSetRefs: [interestSetEvent.id],
    );

    final interestsEvent = interests.toEventMessage(keyStore);

    return (
      interestSet: interestSet,
      interests: interests,
      interestSetEvent: interestSetEvent,
      interestsEvent: interestsEvent
    );
  }

  Future<({UserDelegation userDelegation, EventMessage userDelegationEvent})> _buildUserDelegation({
    required KeyStore keyStore,
  }) async {
    final userDelegation = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationWith(pubkey: keyStore.publicKey);

    final userDelegationEvent = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildDelegationEventFrom(userDelegation);

    return (userDelegation: userDelegation, userDelegationEvent: userDelegationEvent);
  }

  ({FollowList followList, EventMessage followListEvent}) _buildFollowList({
    required KeyStore keyStore,
  }) {
    final onboardingData = ref.read(onboardingDataProvider);

    var followees = onboardingData.followees;

    if (followees == null) {
      final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
      final service = ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName!));
      followees = service.getValue<List<String>>(followeesListPersistanceKey);
    }

    if (followees == null) {
      throw Exception('Failed to create follow list, followees is null');
    }

    final followList = FollowList(
      pubkey: keyStore.publicKey,
      list: followees.map((pubkey) => Followee(pubkey: pubkey)).toList(),
    );

    final followListEvent = followList.toEventMessage(keyStore);

    return (followList: followList, followListEvent: followListEvent);
  }

  static const String followeesListPersistanceKey = 'OnboardingCompleteNotifier:followees';

  EventMessage? _buildAvatarFileMetadataEvent({required KeyStore keyStore}) {
    return ref.read(onboardingDataProvider).avatarFileMetadata?.toEventMessage(keyStore);
  }
}
