import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_coins_notifier_provider.c.g.dart';

@riverpod
class SendCoinsNotifier extends _$SendCoinsNotifier {
  @override
  Future<void> build() async {
    state = const AsyncData(null);
  }

  Future<void> send({
    required Wallet wallet,
    required String receiverAddress,
    required String amount,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionClient = await ref.watch(ionIdentityClientProvider.future);
      await ionClient.wallets.broadcastTransaction(wallet, receiverAddress, amount);
    });
  }
}
