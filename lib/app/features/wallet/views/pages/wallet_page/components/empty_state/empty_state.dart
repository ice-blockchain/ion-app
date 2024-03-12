import 'package:flutter/material.dart';
import 'package:ice/app/components/empty_list/empty_list.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/generated/assets.gen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.tabType,
  });

  final WalletTabType tabType;

  AssetGenImage getEmptyListAsset() {
    switch (tabType) {
      case WalletTabType.coins:
        return Assets.images.misc.emptyCoins;
      case WalletTabType.nfts:
        return Assets.images.misc.emptyNft;
    }
  }

  AssetGenImage getBottomActionAsset() {
    switch (tabType) {
      case WalletTabType.coins:
        return Assets.images.icons.iconButtonManagecoin;
      case WalletTabType.nfts:
        return Assets.images.icons.iconButtonWalletnft;
    }
  }

  String getEmptyListTitle(BuildContext context) {
    switch (tabType) {
      case WalletTabType.coins:
        return context.i18n.wallet_empty_coins;
      case WalletTabType.nfts:
        return context.i18n.wallet_empty_nfts;
    }
  }

  String getBottomActionTitle(BuildContext context) {
    switch (tabType) {
      case WalletTabType.coins:
        return context.i18n.wallet_manage_coins;
      case WalletTabType.nfts:
        return context.i18n.wallet_buy_nfts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: EmptyList(
              asset: getEmptyListAsset(),
              title: getEmptyListTitle(context),
            ),
          ),
          BottomAction(
            asset: getBottomActionAsset(),
            title: getBottomActionTitle(context),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
