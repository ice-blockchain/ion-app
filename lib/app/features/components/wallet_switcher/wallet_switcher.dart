// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/components/wallet_icon/wallet_icon.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class WalletSwitcher extends ConsumerWidget {
  const WalletSwitcher({
    super.key,
  });

  Widget _buildWalletSwitcher({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
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
        title,
        style: context.theme.appTextThemes.subtitle2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(currentWalletDataProvider).valueOrNull;

    if (walletData == null) {
      return Skeleton(
        child: _buildWalletSwitcher(context: context, title: 'main', onPressed: () {}),
      );
    }
    return _buildWalletSwitcher(
      context: context,
      title: walletData.name,
      onPressed: () {
        WalletsRoute().push<void>(context);
      },
    );
  }
}
