import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class ManageWalletTile extends ConsumerWidget {
  const ManageWalletTile({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(walletByIdProvider(id: walletId));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ListItem(
        onTap: () {
          EditWalletRoute(walletId: walletId).push<void>(context);
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
            color: context.theme.appColors.tertararyText,
          ),
        ),
        trailing: Assets.images.icons.iconArrowRight.icon(),
        contentPadding: EdgeInsets.only(
          left: 16.0.s,
          top: 11.0.s,
          bottom: 11.0.s,
          right: 12.0.s,
        ),
        backgroundColor: context.theme.appColors.tertararyBackground,
      ),
    );
  }
}
