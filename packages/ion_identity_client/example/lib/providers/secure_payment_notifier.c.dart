// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/current_username_notifier.c.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_payment_notifier.c.g.dart';

@riverpod
class SecurePaymentNotifier extends _$SecurePaymentNotifier {
  @override
  FutureOr<void> build() {}

  Future<Map<String, dynamic>> startSecurePayment(
    String destinationAddress,
    String amount,
  ) async {
    final currentUser = ref.read(currentUsernameNotifierProvider)!;
    final ion = await ref.read(ionIdentityProvider.future);

    final wallets = await ion(username: currentUser).wallets.getWallets();
    final wallet = wallets[wallets.length - 1];

    return await ion(username: currentUser).wallets.sendTransaction(
          wallet,
          destinationAddress,
          amount,
        );
  }
}
