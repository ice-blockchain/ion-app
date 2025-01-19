// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageCoinItem extends ConsumerWidget {
  const ManageCoinItem({
    required this.manageCoin,
    super.key,
  });

  final ManageCoinData manageCoin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coin = manageCoin.coin;
    return ListItem(
      title: Text(coin.name),
      subtitle: Text(coin.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: coin.iconUrl.coinIcon(size: 36.0.s),
      trailing: manageCoin.isSelected
          ? Assets.svg.iconBlockCheckboxOn.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
      onTap: () {
        ref.read(manageCoinsNotifierProvider.notifier).switchCoin(coinId: coin.id);
      },
    );
  }
}
