// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CoinIdButton extends ConsumerWidget {
  const CoinIdButton({
    required this.coinId,
    required this.onTap,
    super.key,
  });

  final String coinId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final coinDataResult = ref.watch(coinInWalletByIdProvider(coinId: coinId));

    // TODO: Not implemented
    return const SizedBox.shrink();
    // return coinDataResult.maybeWhen(
    //   data: (coinInWallet) => CoinButton(
    //     coinInWallet: coinInWallet!,
    //     onTap: onTap,
    //   ),
    //   orElse: () => ItemLoadingState(
    //     itemHeight: 60.0.s,
    //   ),
    // );
  }
}
