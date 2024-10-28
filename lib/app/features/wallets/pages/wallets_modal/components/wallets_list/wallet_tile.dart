// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/wallet_data.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletTile extends ConsumerWidget {
  const WalletTile({
    required this.walletData,
    super.key,
  });

  final WalletData walletData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWalletId = ref.watch(currentWalletIdProvider).valueOrNull;
    final isSelected = walletData.id == selectedWalletId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ListItem(
        isSelected: isSelected,
        onTap: () {
          if (!isSelected) {
            ref.read(selectedWalletIdNotifierProvider.notifier).selectedWalletId = walletData.id;
          }
        },
        leading: Avatar(
          size: 36.0.s,
          imageUrl: walletData.icon,
        ),
        title: Text(
          walletData.name,
        ),
        subtitle: Text(
          formatToCurrency(walletData.balance),
          style: context.theme.appTextThemes.caption3.copyWith(
            color: isSelected
                ? context.theme.appColors.onPrimaryAccent
                : context.theme.appColors.tertararyText,
          ),
        ),
        trailing: isSelected == true
            ? Assets.svg.iconCheckboxOn.icon(color: context.theme.appColors.onPrimaryAccent)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 11.0.s),
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
