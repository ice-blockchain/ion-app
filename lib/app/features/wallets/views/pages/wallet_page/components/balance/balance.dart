// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance_visibility_action.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/num.dart';

class Balance extends ConsumerWidget {
  const Balance({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWalletData = ref.watch(currentWalletViewDataProvider);
    final currentWallet = currentWalletData.valueOrNull;
    final walletBalance = currentWallet?.usdBalance ?? 0;
    final isLoading = currentWalletData.isLoading;

    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);
    final hitSlop = 5.0.s;

    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 6.0.s - hitSlop,
              bottom: 8.0.s - hitSlop,
            ),
            child: BalanceVisibilityAction(hitSlop: hitSlop, isLoading: isLoading),
          ),
          if (isLoading)
            ContainerSkeleton(
              width: 124.0.s,
              height: 30.0.s,
              margin: EdgeInsets.symmetric(vertical: 5.0.s),
            )
          else
            Text(
              isBalanceVisible ? formatToCurrency(walletBalance) : '********',
              style: context.theme.appTextThemes.headline1
                  .copyWith(color: context.theme.appColors.primaryText),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 12.0.s,
              bottom: 16.0.s,
            ),
            child: BalanceActions(
              isLoading: isLoading,
              onReceive: () => ReceiveCoinRoute().push<void>(context),
              onSend: () {
                ref.read(sendAssetFormControllerProvider().notifier).reset();
                CoinSendRoute().push<void>(context);
              },
              onNeedToEnable2FA: () => SecureAccountModalRoute().push<void>(context),
            ),
          ),
        ],
      ),
    );
  }
}
