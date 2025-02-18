// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_button.dart';

class CoinIdButton extends ConsumerWidget {
  const CoinIdButton({
    required this.onTap,
    required this.coinAbbreviation,
    super.key,
  });

  final VoidCallback onTap;
  final String coinAbbreviation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDataResult = ref.watch(
      coinInWalletByAbbreviationProvider(coinAbbreviation: coinAbbreviation),
    );

    return coinDataResult.maybeWhen(
      data: (coinInWallet) => CoinButton(
        coinInWallet: coinInWallet!,
        onTap: onTap,
      ),
      orElse: () => ItemLoadingState(
        itemHeight: 60.0.s,
      ),
    );
  }
}
