// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
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

      try {
        final event = await ref
            .read(ionConnectNotifierProvider.notifier)
            .buildEventFromTagsAndSignWithMasterKey(
          tags: [
            ['b', mainWallet.signingKey.publicKey],
          ],
          kind: DeletionRequest.kind,
          onVerifyIdentity: onVerifyIdentity,
        );

        await ref.read(ionConnectNotifierProvider.notifier).sendEvent(event, cache: false);

        // clean ion identity data
        final ionIdentity = await ref.read(ionIdentityProvider.future);

        await ionIdentity(username: currentIdentityKeyName).auth.deleteUser(
              base64Kind5Event: base64.encode(utf8.encode(json.encode(event.toJson().last))),
            );
      } on PasskeyCancelledException {
        return;
      }

      // clean local storage data
      final localStorage =
          ref.read(userPreferencesServiceProvider(identityKeyName: currentIdentityKeyName));
      await localStorage.clear();
    });
  }
}
