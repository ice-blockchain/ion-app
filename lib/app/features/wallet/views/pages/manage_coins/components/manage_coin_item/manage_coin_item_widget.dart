// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageCoinItemWidget extends ConsumerWidget {
  const ManageCoinItemWidget({
    required this.coin,
    super.key,
  });

  final CoinData coin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(manageCoinsNotifierProvider).maybeMap(
          data: (data) => data.value[coin.id]?.isSelected ?? false,
          orElse: () => false,
        );
    return ListItem(
      title: Text(coin.name),
      subtitle: Text(coin.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: coin.iconUrl.coinIcon(size: 36.0.s),
      trailing: isSelected
          ? Assets.svg.iconBlockCheckboxOn.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
      onTap: () {
        ref.read(manageCoinsNotifierProvider.notifier).switchCoin(coin: coin);
      },
    );
  }
}
