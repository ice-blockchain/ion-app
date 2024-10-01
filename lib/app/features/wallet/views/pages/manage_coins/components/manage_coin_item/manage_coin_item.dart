// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/generated/assets.gen.dart';

class ManageCoinItem extends HookConsumerWidget {
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
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    final coinData = manageCoinData.coinData;

    return ListItem(
      title: Text(coinData.name),
      subtitle: Text(coinData.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: coinData.iconUrl.icon(size: 36.0.s),
      trailing: _getCheckbox(),
      onTap: () {
        hideKeyboardAndCallOnce(
          callback: () {
            ref
                .read(manageCoinsNotifierProvider.notifier)
                .switchCoin(coinId: coinData.abbreviation);
          },
        );
      },
    );
  }
}
