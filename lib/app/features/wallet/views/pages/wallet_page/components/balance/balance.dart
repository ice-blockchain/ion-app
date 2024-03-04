import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
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
    final ValueNotifier<bool> isVisible = useState<bool>(true);
    final AssetGenImage iconAsset = isVisible.value
        ? Assets.images.icons.iconBlockEyeOn
        : Assets.images.icons.iconBlockEyeOff;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.s),
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
              SizedBox(width: 6.0.s),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                child: iconAsset.icon(
                  color: context.theme.appColors.secondaryText,
                ),
                onTap: () {
                  isVisible.value = !isVisible.value;
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.s),
            child: Text(
              isVisible.value ? '\$${walletData.balance}' : '********',
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
