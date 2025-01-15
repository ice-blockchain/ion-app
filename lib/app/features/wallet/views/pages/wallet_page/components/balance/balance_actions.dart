// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BalanceActions extends ConsumerWidget {
  const BalanceActions({
    required this.onReceive,
    required this.onSend,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onReceive;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Button.compact(
            leadingIcon: Assets.svg.iconButtonSend.icon(),
            label: Text(
              'Test button',
            ),
            onPressed: () async {
              final ionIdentityClient =
                  await ref.read(ionIdentityClientProvider.future);
              // final wallet = await ionIdentityClient.wallets.createWallet(
              //   network: 'TonTestnet',
              //   name: 'TonTestnet wallet',
              //   onVerifyIdentity: ({
              //     required onBiometricsFlow,
              //     required onPasskeyFlow,
              //     required onPasswordFlow,
              //   }) =>
              //       onPasskeyFlow(),
              // );
              final wallets = await ionIdentityClient.wallets.getWallets();
              final walletViews = await ionIdentityClient.wallets.getWalletViews();
              print('hello');
            },
          ),
        ),
        Expanded(
          child: Button.compact(
            leadingIcon: Assets.svg.iconButtonSend.icon(),
            label: Text(
              context.i18n.wallet_send,
            ),
            onPressed: isLoading ? () {} : onSend,
          ),
        ),
        SizedBox(
          width: 12.0.s,
        ),
        Expanded(
          child: Button.compact(
            type: isLoading ? ButtonType.primary : ButtonType.outlined,
            leadingIcon: Assets.svg.iconButtonReceive.icon(),
            label: Text(
              context.i18n.wallet_receive,
            ),
            onPressed: isLoading ? () {} : onReceive,
          ),
        ),
      ],
    );

    return isLoading ? Skeleton(child: child) : child;
  }
}
