import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user_preferences/providers/user_preferences_provider.dart';
import 'package:ice/app/features/user_preferences/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ice/generated/assets.gen.dart';

class Balance extends HookConsumerWidget {
  const Balance({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WalletData walletData = ref.watch(walletDataNotifierProvider);
    final bool isBalanceVisible = isBalanceVisibleSelector(ref);
    final AssetGenImage iconAsset = isBalanceVisible
        ? Assets.images.icons.iconBlockEyeOn
        : Assets.images.icons.iconBlockEyeOff;
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0.s,
        bottom: 16.0.s,
        left: ScreenSideOffset.defaultSmallMargin,
        right: ScreenSideOffset.defaultSmallMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                context.i18n.wallet_balance,
                style: context.theme.appTextThemes.subtitle2
                    .copyWith(color: context.theme.appColors.secondaryText),
              ),
              TextButton(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: iconAsset.icon(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
                onPressed: () {
                  ref
                      .watch(userPreferencesNotifierProvider.notifier)
                      .switchBalanceVisibility();
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0.s),
            child: Text(
              isBalanceVisible ? '\$${walletData.balance}' : '********',
              style: context.theme.appTextThemes.headline1
                  .copyWith(color: context.theme.appColors.primaryText),
            ),
          ),
          const BalanceActions(),
        ],
      ),
    );
  }
}
