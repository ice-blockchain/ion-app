// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/core/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.dart';
import 'package:ion/app/features/user/model/follow_list.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:ion/app/features/user/model/interests.dart';
import 'package:ion/app/features/user/model/user_delegation.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
import 'package:ion/app/services/media_service/media_service.dart';
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
        final (:name, :displayName, :languages, :followees, :avatar) =
            ref.read(onboardingDataProvider.notifier).requireValues();

        final (relayUrls, nostrKeyStore) = await (
          _assignUserRelays(followees: followees),
          _generateNostrKeyStore(),
        ).wait;

        final (:userRelays, :userRelaysEvent) =
            _buildUserRelays(keyStore: nostrKeyStore, relayUrls: relayUrls);

        // Add user relays to cache first because other actions rely on it
        ref.read(nostrCacheProvider.notifier).cache(userRelays);

        final (:userMetadata, :userMetadataEvent) = await _buildUserMetadata(
          keyStore: nostrKeyStore,
          avatar: avatar,
          name: name,
          displayName: displayName,
        );

        final (:interestSet, :interests, :interestSetEvent, :interestsEvent) =
            _buildUserLanguages(keyStore: nostrKeyStore, languages: languages);

        final (:userDelegation, :userDelegationEvent) =
            await _buildUserDelegation(keyStore: nostrKeyStore);

        final (:followList, :followListEvent) =
            _buildFollowList(keyStore: nostrKeyStore, followees: followees);

        await ref.read(nostrNotifierProvider.notifier).send([
          //TODO:uncomment when switched to our relays
          // damus returns "rate-limited: you are noting too much"
          // followListEvent,
          // interestSetEvent,
          // interestsEvent,
          userRelaysEvent,
          userMetadataEvent,
          userDelegationEvent,
        ]);

        [followList, interestSet, interests, userMetadata, userDelegation]
            .forEach(ref.read(nostrCacheProvider.notifier).cache);

        ref.read(onboardingDataProvider.notifier).reset();
      },
    );
  }

  Future<List<String>> _assignUserRelays({required List<String> followees}) async {
    final userIdentity = (await ref.read(currentUserIdentityProvider.future))!;
    if (userIdentity.ionConnectRelays.isNotEmpty) {
      return userIdentity.ionConnectRelays;
    }

    return ref.read(currentUserIdentityProvider.notifier).assignUserRelays(followees: followees);
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

  Future<({UserMetadata userMetadata, EventMessage userMetadataEvent})> _buildUserMetadata({
    required KeyStore keyStore,
    required String name,
    required String displayName,
    MediaFile? avatar,
  }) async {
    MediaAttachment? mediaAttachment;
    if (avatar != null) {
      mediaAttachment = await ref.read(nostrUploadNotifierProvider.notifier).upload(avatar);
    }

    final userMetadata = UserMetadata(
      pubkey: keyStore.publicKey,
      name: name,
      displayName: displayName,
      picture: mediaAttachment?.url,
      media: mediaAttachment != null ? {mediaAttachment.url: mediaAttachment} : {},
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
    required List<String> followees,
  }) {
    final followList = FollowList(
      pubkey: keyStore.publicKey,
      list: followees.map((pubkey) => Followee(pubkey: pubkey)).toList(),
    );

    final followListEvent = followList.toEventMessage(keyStore);

    return (followList: followList, followListEvent: followListEvent);
  }
}
