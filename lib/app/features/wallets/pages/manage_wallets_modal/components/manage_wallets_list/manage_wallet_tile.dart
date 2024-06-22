import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class ManageWalletTile extends StatelessWidget {
  const ManageWalletTile({
    required this.walletData,
    super.key,
  });

  final WalletData walletData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UiSize.xxSmall),
      child: ListItem(
        onTap: () {
          IceRoutes.editWallet.push(context, payload: walletData);
        },
        leading: Avatar(
          size: 36.0.s,
          imageUrl: walletData.icon,
          borderRadius: BorderRadius.circular(UiSize.xSmall),
        ),
        title: Text(
          walletData.name,
        ),
        subtitle: Text(
          formatToCurrency(walletData.balance),
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.tertararyText,
          ),
        ),
        trailing: Assets.images.icons.iconArrowRight.icon(),
        contentPadding: EdgeInsets.only(
          left: UiSize.medium,
          top: 11.0.s,
          bottom: 11.0.s,
          right: UiSize.small,
        ),
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
