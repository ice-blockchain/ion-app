// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generate_signature_notifier.r.g.dart';

@riverpod
class GenerateSignatureNotifier extends _$GenerateSignatureNotifier {
  @override
  FutureOr<GenerateSignatureResponse?> build() => null;

  Future<void> generateSignature(String message, String walletId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final username = ref.read(currentUsernameNotifierProvider) ?? '';
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      return ionIdentity(username: username).wallets.generateMessageSignatureWithPasskey(
            walletId,
            message,
          );
    });
  }
}
