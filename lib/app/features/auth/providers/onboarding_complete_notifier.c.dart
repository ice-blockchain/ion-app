// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/onboarding_data_provider.c.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/file_metadata.c.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/interests.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:nostr_dart/nostr_dart.dart';
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
        final (relayUrls, eventSigner) =
            await (_assignUserRelays(), _generateNostrEventSigner()).wait;

        // Build and cache user relays first because it is used to `sendEvents`, upload avatar
        final userRelaysEvent = await _buildAndCacheUserRelays(relayUrls: relayUrls);

        // Build and cache user chat relays
        final userChatRelaysEvent = await _buildAndCacheUserChatRelays(
          relayUrls: relayUrls,
        );

        // Send user delegation event in advance so all subsequent events pass delegation attestation
        final userDelegationEvent = await _buildUserDelegation(
          pubkey: eventSigner.publicKey,
          onVerifyIdentity: onVerifyIdentity,
        );

        await ref
            .read(nostrNotifierProvider.notifier)
            .sendEvents([userDelegationEvent, userRelaysEvent, userChatRelaysEvent]);

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

  Future<EventSigner> _generateNostrEventSigner() async {
    final currentUserNostrEventSigner = await ref.read(currentUserNostrEventSignerProvider.future);
    if (currentUserNostrEventSigner != null) {
      // Event signer already exists, reuse it
      return currentUserNostrEventSigner;
    }

    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
    final privateKey = ionIdentityClient.auth.getUserPrivateKey();
    if (privateKey != null) {
      // Private key was generated during the auth flow (password), reuse it
      return ref
          .read(nostrEventSignerProvider(currentIdentityKeyName).notifier)
          .generateFromPrivate(privateKey);
    }

    // Generate a new event signer
    return ref.read(nostrEventSignerProvider(currentIdentityKeyName).notifier).generate();
  }

  Future<EventMessage> _buildAndCacheUserRelays({required List<String> relayUrls}) async {
    final userRelays = UserRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final userRelaysEvent = await ref.read(nostrNotifierProvider.notifier).sign(userRelays);

    ref.read(nostrCacheProvider.notifier).cache(UserRelaysEntity.fromEventMessage(userRelaysEvent));

    return userRelaysEvent;
  }

  Future<EventMessage> _buildAndCacheUserChatRelays({required List<String> relayUrls}) async {
    final userChatRelays = UserChatRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final userChatRelaysEvent = await ref.read(nostrNotifierProvider.notifier).sign(userChatRelays);

    ref
        .read(nostrCacheProvider.notifier)
        .cache(UserChatRelaysEntity.fromEventMessage(userChatRelaysEvent));

    return userChatRelaysEvent;
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

  Future<EventMessage> _buildUserDelegation({
    required String pubkey,
    required OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  }) async {
    final userDelegationData = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationDataWith(pubkey: pubkey);

    return ref.read(userDelegationManagerProvider.notifier).buildDelegationEventFrom(
          userDelegationData,
          onVerifyIdentity,
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
