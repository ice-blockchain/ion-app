// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:ion/app/features/user/model/interests.dart';
import 'package:ion/app/features/user/model/user_delegation.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
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
        final (:name, :displayName, :languages, :followees) =
            ref.read(onboardingDataProvider.notifier).requireValues();

        final (relayUrls, nostrKeyStore) = await (
          _assignUserRelays(followees: followees),
          _generateNostrKeyStore(),
        ).wait;

        final (:userRelays, :userRelaysEvent) =
            _buildUserRelays(keyStore: nostrKeyStore, relayUrls: relayUrls);

        final (:userMetadata, :userMetadataEvent) =
            _buildUserMetadata(keyStore: nostrKeyStore, name: name, displayName: displayName);

        final (:interestSet, :interests, :interestSetEvent, :interestsEvent) =
            _buildUserLanguages(keyStore: nostrKeyStore, languages: languages);

        final (:userDelegation, :userDelegationEvent) =
            await _buildUserDelegation(keyStore: nostrKeyStore);

        ref.read(nostrCacheProvider.notifier).cache(userRelays);

        await ref.read(nostrNotifierProvider.notifier).send([
          //TODO:add folowees here
          interestSetEvent,
          interestsEvent,
          userRelaysEvent,
          userMetadataEvent,
          userDelegationEvent,
        ]);

        [userMetadata, userDelegation].forEach(ref.read(nostrCacheProvider.notifier).cache);
      },
    );
  }

  Future<List<String>> _assignUserRelays({required List<String> followees}) async {
    final userIdentity = (await ref.read(currentUserIdentityProvider.future))!;
    if (userIdentity.ionConnectRelays.isNotEmpty) {
      return userIdentity.ionConnectRelays;
    }

    //TODO: Add identity io request here.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [
      'wss://relay.damus.io',
      'wss://relay.damus.io',
      'wss://relay.damus.io',
    ];
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
    required String name,
    required String displayName,
  }) {
    final userMetadata = UserMetadata(
      pubkey: keyStore.publicKey,
      name: name,
      displayName: displayName,
    );

    final userMetadataEvent = userMetadata.toEventMessage(keyStore);

    return (userMetadata: userMetadata, userMetadataEvent: userMetadataEvent);
  }

  ({
    InterestSet interestSet,
    Interests interests,
    EventMessage interestSetEvent,
    EventMessage interestsEvent
  }) _buildUserLanguages({
    required KeyStore keyStore,
    required List<String> languages,
  }) {
    final interestSet = InterestSet(
      pubkey: keyStore.publicKey,
      type: InterestSetType.languages,
      hashtags: languages,
    );

    final interestSetEvent = interestSet.toEventMessage(keyStore);

    final interests = Interests(
      pubkey: keyStore.publicKey,
      hashtags: [],
      eventIds: [interestSetEvent.id],
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
}
