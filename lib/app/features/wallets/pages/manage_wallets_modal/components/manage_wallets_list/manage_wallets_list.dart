import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/pages/manage_wallets_modal/components/manage_wallets_list/manage_wallet_tile.dart';
import 'package:ice/app/features/wallets/providers/selectors/wallets_data_selectors.dart';

class ManageWalletsList extends HookConsumerWidget {
  const ManageWalletsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WalletData> walletsData = walletsDataSelector(ref);
    return Padding(
      padding: EdgeInsets.only(top: 6.0.s),
      child: Column(
        children: walletsData
            .map(
              (WalletData walletData) => ManageWalletTile(
                walletData: walletData,
              ),
            )
            .toList(),
      ),
    );
  }
}
