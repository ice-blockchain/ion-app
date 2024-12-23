// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/components/wallet_icon/wallet_icon.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageWalletTile extends ConsumerWidget {
  const ManageWalletTile({
    required this.walletId,
    super.key,
  });

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletData = ref.watch(walletByIdProvider(id: walletId)).valueOrNull;

    // TODO: add loading and error states
    if (walletData == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.s),
        child: Skeleton(
          child: ListItem(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ListItem(
        onTap: () {
          EditWalletRoute(walletId: walletId).push<void>(context);
        },
        leading: const WalletIcon(),
        title: Text(
          walletData.name,
        ),
        subtitle: Text(
          formatToCurrency(walletData.balance),
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.tertararyText,
          ),
        ),
        trailing: Assets.svg.iconArrowRight.icon(),
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
