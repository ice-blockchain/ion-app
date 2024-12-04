// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.dart';
import 'package:ion/app/features/user/model/follow_list.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:ion/app/features/user/model/interests.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
import 'package:ion/app/services/logger/logger.dart';
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

        // Build and cache user relays first because it is used to `sendEvents`, upload avatar
        final userRelaysEvent = await _buildAndCacheUserRelays(relayUrls: relayUrls);

        // Send user delegation event in advance so all subsequent events pass delegation attestation
        final userDelegationEvent = await _buildUserDelegation(pubkey: nostrKeyStore.publicKey);

        await ref
            .read(nostrNotifierProvider.notifier)
            .sendEvents([userDelegationEvent, userRelaysEvent]);

        final uploadedAvatar = await _uploadAvatar();

        final userMetadata = _buildUserMetadata(avatarAttachment: uploadedAvatar?.mediaAttachment);

        final (:interestSetData, :interestsData) = _buildUserLanguages();

        final followList = _buildFollowList();

        await ref.read(nostrNotifierProvider.notifier).sendEntitiesData([
          userMetadata,
          followList,
          interestSetData,
          interestsData,
          if (uploadedAvatar != null) uploadedAvatar.fileMetadata,
        ]);
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

  Future<EventMessage> _buildAndCacheUserRelays({required List<String> relayUrls}) async {
    final userRelays = UserRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final userRelaysEvent = await ref.read(nostrNotifierProvider.notifier).sign(userRelays);

    ref.read(nostrCacheProvider.notifier).cache(UserRelaysEntity.fromEventMessage(userRelaysEvent));

    return userRelaysEvent;
  }

  UserMetadata _buildUserMetadata({MediaAttachment? avatarAttachment}) {
    final OnboardingState(:name, :displayName) = ref.read(onboardingDataProvider);

    if (name == null) {
      throw RequiredFieldIsEmptyException(field: 'name');
    }

    if (displayName == null) {
      throw RequiredFieldIsEmptyException(field: 'displayName');
    }

    return UserMetadata(
      name: name,
      displayName: displayName,
      picture: avatarAttachment?.url,
      media: avatarAttachment != null ? {avatarAttachment.url: avatarAttachment} : {},
    );
  }

  ({InterestSetData interestSetData, InterestsData interestsData}) _buildUserLanguages() {
    final OnboardingState(:languages) = ref.read(onboardingDataProvider);

    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (languages == null || languages.isEmpty) {
      throw RequiredFieldIsEmptyException(field: 'languages');
    }

    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final interestSetData = InterestSetData(
      type: InterestSetType.languages,
      hashtags: languages,
    );

    final interestsData = InterestsData(
      hashtags: [],
      interestSetRefs: [interestSetData.toReplaceableEventReference(currentPubkey)],
    );

    return (interestSetData: interestSetData, interestsData: interestsData);
  }

  Future<EventMessage> _buildUserDelegation({required String pubkey}) async {
    final userDelegationData = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationDataWith(pubkey: pubkey);

    return ref
        .read(userDelegationManagerProvider.notifier)
        .buildDelegationEventFrom(userDelegationData);
  }

  FollowListData _buildFollowList() {
    final OnboardingState(:followees) = ref.read(onboardingDataProvider);

    return FollowListData(
      list: followees == null ? [] : followees.map((pubkey) => Followee(pubkey: pubkey)).toList(),
    );
  }

  Future<({FileMetadata fileMetadata, MediaAttachment mediaAttachment})?> _uploadAvatar() async {
    try {
      final avatar = ref.read(onboardingDataProvider).avatar;
      if (avatar != null) {
        return await ref
            .read(nostrUploadNotifierProvider.notifier)
            .upload(avatar, alt: FileAlt.avatar);
      }
    } catch (error, stackTrace) {
      // intentionally ignore upload avatar exceptions
      Logger.log('Upload avatar exception', error: error, stackTrace: stackTrace);
    }
    return null;
  }
}
