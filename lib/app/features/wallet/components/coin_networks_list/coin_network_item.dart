// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/utils/num.dart';

class CoinNetworkItem extends ConsumerWidget {
  const CoinNetworkItem({
    required this.coinId,
    required this.networkType,
    required this.onTap,
    super.key,
  });

  final String coinId;
  final NetworkType networkType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDataResult = ref.watch(coinByIdProvider(coinId: coinId));
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);

    return coinDataResult.maybeWhen(
      data: (coinData) {
        return ListItem(
          title: Row(
            children: [
              Text(coinData.name),
              SizedBox(
                width: 6.0.s,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 6.0.s,
                  right: 6.0.s,
                  bottom: 2.0.s,
                ),
                decoration: BoxDecoration(
                  color: context.theme.appColors.attentionBlock,
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                child: Text(
                  networkType.getDisplayName(context),
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(coinData.abbreviation),
          backgroundColor: context.theme.appColors.tertararyBackground,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              coinData.iconUrl.icon(size: 36.0.s),
              Positioned(
                bottom: -3.0.s,
                right: -3.0.s,
                child: networkType.iconAsset.icon(size: 16.0.s),
              ),
            ],
          ),
          onTap: onTap,
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isBalanceVisible ? coinData.amount.toString() : '****',
                style: context.theme.appTextThemes.body
                    .copyWith(color: context.theme.appColors.primaryText),
              ),
              Text(
                isBalanceVisible ? formatToCurrency(coinData.balance) : '******',
                style: context.theme.appTextThemes.caption3
                    .copyWith(color: context.theme.appColors.secondaryText),
              ),
            ],
          ),
        );
      },
      orElse: () => ItemLoadingState(
        itemHeight: 60.0.s,
      ),
    );
  }
}
