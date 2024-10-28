// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageCoinItem extends ConsumerWidget {
  const ManageCoinItem({
    required this.manageCoinData,
    super.key,
  });

  final ManageCoinData manageCoinData;

  Widget _getCheckbox() {
    return manageCoinData.isSelected
        ? Assets.svg.iconBlockCheckboxOn.icon()
        : Assets.svg.iconBlockCheckboxOff.icon();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinData = manageCoinData.coinData;

    return ListItem(
      title: Text(coinData.name),
      subtitle: Text(coinData.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: coinData.iconUrl.icon(size: 36.0.s),
      trailing: _getCheckbox(),
      onTap: () {
        ref.read(manageCoinsNotifierProvider.notifier).switchCoin(coinId: coinData.abbreviation);
      },
    );
  }
}
