import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/wallet_address_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion_identity_client/ion_identity.dart';

void useLoadWalletToReceiveCoins(
  WidgetRef ref, [
  List<Object?> keys = const [],
]) {
  useOnInit(
    () async {
      final network = ref.read(receiveCoinsFormControllerProvider).selectedNetwork;
      var address = await ref.read(walletAddressNotifierProvider.notifier).loadWalletAddress();

      if (address == null && network != null && ref.context.mounted) {
        await guardPasskeyDialog(
          ref.context,
          (child) {
            return RiverpodVerifyIdentityRequestBuilder(
              provider: walletAddressNotifierProvider,
              requestWithVerifyIdentity: (OnVerifyIdentity<Wallet> onVerifyIdentity) async {
                address = await ref
                    .read(
                      walletAddressNotifierProvider.notifier,
                    )
                    .createWallet(
                      onVerifyIdentity: onVerifyIdentity,
                      network: network,
                    );
              },
              child: child,
            );
          },
        );
      }

      if (address != null) {
        ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address!);
      }
    },
    keys,
  );
}
