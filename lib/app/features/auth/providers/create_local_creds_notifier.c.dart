// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_local_creds_notifier.c.g.dart';

@riverpod
class CreateLocalCredsNotifier extends _$CreateLocalCredsNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> createLocalCreds(OnVerifyIdentity<CredentialResponse> onVerifyIdentity) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      await ionIdentity.auth.createNewCredentials(
        ({required onPasskeyFlow, required onPasswordFlow}) => onPasskeyFlow(),
      );
    });
  }
}
