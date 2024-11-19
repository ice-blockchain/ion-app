// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/components/wallet_icon/wallet_icon.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class WalletSwitcher extends ConsumerWidget {
  const WalletSwitcher({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(currentWalletDataProvider).valueOrNull;

    // TODO: add proper loading and error handling
    if (walletData == null) {
      return const SizedBox.shrink();
    }

    return Button.dropdown(
      onPressed: () {
        WalletsRoute().push<void>(context);
      },
      leadingIcon: const WalletIcon(
        size: 28,
        iconSize: 18.6,
        borderRadius: 8,
      ),
      leadingIconOffset: 11.0.s,
      trailingIconOffset: 0.0.s,
      backgroundColor: context.theme.appColors.tertararyBackground,
      label: Text(
        walletData.name,
        style: context.theme.appTextThemes.subtitle2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
