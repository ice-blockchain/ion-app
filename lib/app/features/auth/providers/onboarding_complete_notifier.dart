// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
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
        final delegationTime = DateTime.now();

        final (relayUrls, nostrKeyStore) =
            await (_assignUserRelays(), _generateNostrKeyStore()).wait;

        final userRelaysEvent = _buildUserRelays(relayUrls: relayUrls);

        // Add user relays to cache because it will be used to `sendEvents`, upload avatar
        ref
            .read(nostrCacheProvider.notifier)
            .cache(UserRelaysEntity.fromEventMessage(userRelaysEvent));

        final (userDelegationEvent, uploadedAvatar) = await (
          _buildUserDelegation(pubkey: nostrKeyStore.publicKey, delegationTime: delegationTime),
          _uploadAvatar(),
        ).wait;

        final userMetadataEvent =
            _buildUserMetadata(avatarAttachment: uploadedAvatar?.mediaAttachment);

        final (:interestSetEvent, :interestsEvent) = _buildUserLanguages();

        final followListEvent = _buildFollowList();

        await ref.read(nostrNotifierProvider.notifier).sendEvents([
          // Delegation should be first
          userDelegationEvent,
          userRelaysEvent,
          followListEvent,
          interestSetEvent,
          interestsEvent,
          userMetadataEvent,
          if (uploadedAvatar != null) uploadedAvatar.fileMetadataEvent,
        ]);

        <CacheableEntity>[
          FollowListEntity.fromEventMessage(followListEvent),
          InterestSetEntity.fromEventMessage(interestSetEvent),
          InterestsEntity.fromEventMessage(interestsEvent),
          UserMetadataEntity.fromEventMessage(userMetadataEvent),
          UserDelegationEntity.fromEventMessage(userDelegationEvent),
        ].forEach(ref.read(nostrCacheProvider.notifier).cache);
      },
    );
  }

  Future<List<String>> _assignUserRelays() async {
    final UserDetails(:ionConnectRelays) = (await ref.read(currentUserIdentityProvider.future))!;
    if (ionConnectRelays != null && ionConnectRelays.isNotEmpty) {
      return ionConnectRelays;
    }
    final followees = ref.read(onboardingDataProvider).followees;

    return ref.read(currentUserIdentityProvider.notifier).assignUserRelays(followees: followees);
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

  EventMessage _buildUserMetadata({MediaAttachment? avatarAttachment}) {
    final OnboardingState(:name, :displayName) = ref.read(onboardingDataProvider);

    if (name == null) {
      throw RequiredFieldIsEmptyException(field: 'name');
    }

    if (displayName == null) {
      throw RequiredFieldIsEmptyException(field: 'displayName');
    }

    final userMetadata = UserMetadata(
      name: name,
      displayName: displayName,
      picture: avatarAttachment?.url,
      media: avatarAttachment != null ? {avatarAttachment.url: avatarAttachment} : {},
    );

    return ref.read(nostrNotifierProvider.notifier).sign(userMetadata);
  }

  ({EventMessage interestSetEvent, EventMessage interestsEvent}) _buildUserLanguages() {
    final OnboardingState(:languages) = ref.read(onboardingDataProvider);

    if (languages == null || languages.isEmpty) {
      throw RequiredFieldIsEmptyException(field: 'languages');
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
    required String pubkey,
    DateTime? delegationTime,
  }) async {
    final userDelegationData = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationDataWith(pubkey: pubkey, delegationTime: delegationTime);

    return ref
        .read(userDelegationManagerProvider.notifier)
        .buildDelegationEventFrom(userDelegationData);
  }

  EventMessage _buildFollowList() {
    final OnboardingState(:followees) = ref.read(onboardingDataProvider);

    final followListData = FollowListData(
      list: followees == null ? [] : followees.map((pubkey) => Followee(pubkey: pubkey)).toList(),
    );

    return ref.read(nostrNotifierProvider.notifier).sign(followListData);
  }

  Future<({EventMessage fileMetadataEvent, MediaAttachment mediaAttachment})?>
      _uploadAvatar() async {
    final avatar = ref.read(onboardingDataProvider).avatar;
    if (avatar != null) {
      final (:fileMetadata, :mediaAttachment) =
          await ref.read(nostrUploadNotifierProvider.notifier).upload(avatar);
      return (
        fileMetadataEvent: ref.read(nostrNotifierProvider.notifier).sign(fileMetadata),
        mediaAttachment: mediaAttachment
      );
    }
    return null;
  }
}
