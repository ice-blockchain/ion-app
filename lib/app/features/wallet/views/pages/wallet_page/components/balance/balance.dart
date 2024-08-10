import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/providers/user_preferences_provider.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class Balance extends ConsumerWidget {
  const Balance({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletBalance = ref.watch(currentWalletDataProvider).balance;

    final isBalanceVisible = isBalanceVisibleSelector(ref);
    final iconAsset =
        isBalanceVisible ? Assets.images.icons.iconBlockEyeOn : Assets.images.icons.iconBlockEyeOff;
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
            child: Row(
              children: [
                Text(
                  context.i18n.wallet_balance,
                  style: context.theme.appTextThemes.subtitle2
                      .copyWith(color: context.theme.appColors.secondaryText),
                ),
                TextButton(
                  child: Padding(
                    padding: EdgeInsets.all(hitSlop),
                    child: iconAsset.icon(
                      color: context.theme.appColors.secondaryText,
                    ),
                  ),
                  onPressed: () {
                    ref.watch(userPreferencesNotifierProvider.notifier).switchBalanceVisibility();
                  },
                ),
                Expanded(
                  child: TextButton(
                    child: Text('Secure account'),
                    onPressed: () {
                      ProtectAccountRoute().push<void>(context);
                    },
                  ),
                ),
              ],
            ),
          ),
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
              onReceive: () => ReceiveCoinRoute().push<void>(context),
              onSend: () => CoinSendRoute().push<void>(context),
            ),
          ),
        ],
      ),
    );
  }
}
