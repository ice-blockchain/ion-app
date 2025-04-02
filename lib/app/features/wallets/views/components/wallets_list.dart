// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';

class WalletsList extends ConsumerWidget {
  const WalletsList({
    required this.itemBuilder,
    this.padding,
    super.key,
  });

  final Widget Function(WalletViewData) itemBuilder;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletViews = ref.watch(walletViewsDataNotifierProvider).valueOrNull;

    // TODO: add loading and error states
    if (walletViews == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? EdgeInsetsDirectional.only(top: 6.0.s),
      child: Column(
        children: [
          for (final walletView in walletViews) itemBuilder(walletView),
        ],
      ),
    );
  }
}
