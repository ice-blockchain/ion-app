// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/model/wallet_data.dart';
import 'package:ion/app/features/wallets/pages/wallets_modal/components/wallets_list/wallet_tile.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';

class WalletsList extends ConsumerWidget {
  const WalletsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsData = ref.watch(walletsDataNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(top: 6.0.s),
      child: Column(
        children: walletsData
            .map(
              (WalletData walletData) => WalletTile(
                walletData: walletData,
              ),
            )
            .toList(),
      ),
    );
  }
}
