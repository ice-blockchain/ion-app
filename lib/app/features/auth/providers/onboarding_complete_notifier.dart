// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ice/app/features/user/providers/user_delegation_provider.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_notifier.g.dart';

@riverpod
class OnboardingCompleteNotifier extends _$OnboardingCompleteNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> finish() async {
    final (:name, :displayName, :languages, :followees) =
        ref.read(onboardingDataProvider.notifier).requireValues();

    final (relayUrls, nostrKeyStore) = await (
      _assignUserRelays(followees: followees),
      _generateNostrKeyStore(),
    ).wait;

    final userRelays = UserRelays(
      pubkey: nostrKeyStore.publicKey,
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final userMetadata = UserMetadata(
      pubkey: nostrKeyStore.publicKey,
      name: name,
      displayName: displayName,
    );

    final userDelegation = await ref
        .read(userDelegationManagerProvider.notifier)
        .buildCurrentUserDelegationWith(pubkey: nostrKeyStore.publicKey);

    await ref.read(nostrNotifierProvider.notifier).sendEvents([
      //TODO:add langs and folowees here
      userRelays.toEventMessage(nostrKeyStore),
      userMetadata.toEventMessage(nostrKeyStore),
      await ref
          .read(userDelegationManagerProvider.notifier)
          .buildDelegationEventFrom(userDelegation),
    ]);

    ref.read(usersRelaysStorageProvider.notifier).store(userRelays);
    ref.read(usersMetadataStorageProvider.notifier).store(userMetadata);
    ref.read(usersDelegationStorageProvider.notifier).store(userDelegation);
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
}
