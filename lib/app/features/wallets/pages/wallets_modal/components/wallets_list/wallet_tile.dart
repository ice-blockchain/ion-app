import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:ice/app/features/wallets/providers/selectors/wallets_data_selectors.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletTile extends ConsumerWidget {
  const WalletTile({
    required this.walletData,
    super.key,
  });

  final WalletData walletData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWalletId = walletIdSelector(ref);
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
          borderRadius: BorderRadius.circular(10.0.s),
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
            ? Assets.images.icons.iconCheckboxOn
                .icon(color: context.theme.appColors.onPrimaryAccent)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 11.0.s),
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
