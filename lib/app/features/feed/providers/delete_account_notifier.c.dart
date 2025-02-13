// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_account_notifier.c.g.dart';

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> deleteAccount(
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final mainWallet = ref.read(mainWalletProvider).valueOrNull;
      final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
      if (mainWallet == null) {
        throw MainWalletNotFoundException();
      }
      if (currentIdentityKeyName == null) {
        return;
      }
      final event = await ref
          .read(ionConnectNotifierProvider.notifier)
          .buildEventFromTagsAndSignWithMasterKey(
        tags: [
          ['b', mainWallet.signingKey.publicKey],
        ],
        kind: DeletionRequest.kind,
        onVerifyIdentity: onVerifyIdentity,
      );

      // clean ion connect data
      await ref.read(ionConnectNotifierProvider.notifier).sendEvent(event, cache: false);

      // clean ion identity data
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: currentIdentityKeyName).auth.deleteUser(
            base64Kind5Event: base64.encode(utf8.encode(json.encode(event.toJson().last))),
          );

      // clean local storage data
      final localStorage = ref.read(localStorageProvider);
      await localStorage.clear();

      // // invalidate providers
      ref
        ..invalidate(currentUserIdentityProvider)
        ..invalidate(ionConnectCacheProvider)
        ..invalidate(currentUserIonConnectEventSignerProvider)
        ..invalidate(currentUserDelegationProvider)
        ..invalidate(walletsNotifierProvider)
        ..invalidate(userMetadataProvider);
    });
  }
}
