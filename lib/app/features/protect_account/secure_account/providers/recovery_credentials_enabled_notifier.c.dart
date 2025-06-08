// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_credentials_enabled_notifier.c.g.dart';

@Riverpod(keepAlive: true)
class RecoveryCredentialsEnabled extends _$RecoveryCredentialsEnabled {
  @override
  Future<bool> build() async {
    final selectedUser = ref.watch(authProvider).valueOrNull?.currentIdentityKeyName;
    if (selectedUser == null) {
      return false;
    }

    final ionIdentity = ref.watch(ionIdentityProvider).valueOrNull;
    if (ionIdentity == null) {
      return false;
    }
    final credentials = await ionIdentity(username: selectedUser).auth.getCredentialsList();
    return credentials.any((credential) => credential.kind == CredentialKind.RecoveryKey.name);
  }

  void setEnabled() => state = const AsyncValue.data(true);
}
