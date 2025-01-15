// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';

class WalletsList extends ConsumerWidget {
  const WalletsList({
    required this.itemBuilder,
    super.key,
  });

  final Widget Function(WalletViewData) itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsData = ref.watch(walletsDataNotifierProvider).valueOrNull;

    // TODO: add loading and error states
    if (walletsData == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 6.0.s),
      child: Column(
        children: [
          for (final walletData in walletsData) itemBuilder(walletData),
        ],
      ),
    );
  }
}
