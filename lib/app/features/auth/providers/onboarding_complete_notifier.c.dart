// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/data/models/onboarding_state.c.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/interests.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/badges_notifier.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/user/providers/user_social_profile_provider.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_notifier.c.g.dart';

@riverpod
class OnboardingCompleteNotifier extends _$OnboardingCompleteNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> finish(OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final relayUrls = await _assignUserRelays();

        // BE requires sending user relays alongside the user delegation event
        final userRelaysEvent = await _buildUserRelaysEvent(relayUrls: relayUrls);

        // Send user delegation event in advance so all subsequent events pass delegation attestation
        try {
          final userDelegationEvent =
              await _buildUserDelegation(onVerifyIdentity: onVerifyIdentity);
          await ref
              .read(ionConnectNotifierProvider.notifier)
              .sendEvents([userDelegationEvent, userRelaysEvent]);
        } on PasskeyCancelledException {
          return;
        }

        final uploadedAvatar = await _uploadAvatar();

        final userMetadata =
            await _buildUserMetadata(avatarAttachment: uploadedAvatar?.mediaAttachment);
        final usernameProofsJsonPayloads = await ref.read(
          updateUserSocialProfileProvider(
            data: UserSocialProfileData(
              username: userMetadata.name,
              displayName: userMetadata.displayName,
              referral: ref.read(onboardingDataProvider).referralName,
            ),
          ).future,
        );

        final (:interestSetData, :interestsData) = _buildUserLanguages();

        final followList = _buildFollowList();

        final usernameProofsEvents =
            usernameProofsJsonPayloads.map(EventMessage.fromPayloadJson).toList();
        final updatedProfileBadges = await ref
            .read(updateProfileBadgesWithUsernameProofsProvider(usernameProofsEvents).future);
        await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
          [
            userMetadata,
            followList,
            interestSetData,
            interestsData,
            if (uploadedAvatar != null) uploadedAvatar.fileMetadata,
            if (updatedProfileBadges != null) updatedProfileBadges,
          ],
          additionalEvents: usernameProofsEvents,
        );
      },
    );
  }

  Future<void> addDelegation(OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final isDelegationComplete = await ref.read(delegationCompleteProvider.future);
        if (!isDelegationComplete) {
          try {
            final userDelegationEvent =
                await _buildUserDelegation(onVerifyIdentity: onVerifyIdentity);
            await ref.read(ionConnectNotifierProvider.notifier).sendEvents([userDelegationEvent]);
          } on PasskeyCancelledException {
            return;
          }
        }
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

  Future<EventMessage> _buildUserRelaysEvent({required List<String> relayUrls}) async {
    final userRelays = UserRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    return ref.read(ionConnectNotifierProvider.notifier).sign(userRelays);
  }

  Future<UserMetadata> _buildUserMetadata({MediaAttachment? avatarAttachment}) async {
    final OnboardingState(:name, :displayName) = ref.read(onboardingDataProvider);

    if (name == null) {
      throw RequiredFieldIsEmptyException(field: 'name');
    }

    if (displayName == null) {
      throw RequiredFieldIsEmptyException(field: 'displayName');
    }

    final wallets = await _buildUserWallets();

    return UserMetadata(
      name: name,
      displayName: displayName,
      registeredAt: DateTime.now().microsecondsSinceEpoch,
      picture: avatarAttachment?.url,
      media: avatarAttachment != null ? {avatarAttachment.url: avatarAttachment} : {},
      wallets: wallets,
    );
  }

  Future<Map<String, String>> _buildUserWallets() async {
    final cryptoWallets = await ref.read(mainCryptoWalletsProvider.future);
    return Map.fromEntries(
      cryptoWallets.map((wallet) {
        if (wallet.address == null) return null;
        return MapEntry(wallet.network, wallet.address!);
      }).nonNulls,
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

  Future<EventMessage> _buildUserDelegation({
    required OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  }) async {
    final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final userDelegationData = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationDataWith(pubkey: eventSigner.publicKey);

    return ref.read(ionConnectNotifierProvider.notifier).buildEventFromTagsAndSignWithMasterKey(
          onVerifyIdentity: onVerifyIdentity,
          kind: UserDelegationEntity.kind,
          tags: userDelegationData.tags,
        );
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
            .read(ionConnectUploadNotifierProvider.notifier)
            .upload(avatar, alt: FileAlt.avatar);
      }
    } catch (error, stackTrace) {
      // intentionally ignore upload avatar exceptions
      Logger.log('Upload avatar exception', error: error, stackTrace: stackTrace);
    }
    return null;
  }
}
