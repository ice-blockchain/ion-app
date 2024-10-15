// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generate_signature_notifier.g.dart';

@riverpod
class GenerateSignatureNotifier extends _$GenerateSignatureNotifier {
  @override
  FutureOr<PseudoNetworkSignatureResponse?> build() => null;

  Future<void> generateSignature(String message, String walletId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final username = ref.read(currentUsernameNotifierProvider) ?? '';
      final ionClient = await ref.read(ionClientProvider.future);

      return ionClient(username: username).wallets.generateSignature(walletId, message);
    });
  }
}
