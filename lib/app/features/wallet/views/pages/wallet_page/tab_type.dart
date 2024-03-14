import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum WalletTabType {
  coins,
  nfts;

  AssetGenImage get emptyListAsset {
    return switch (this) {
      WalletTabType.coins => Assets.images.misc.emptyCoins,
      WalletTabType.nfts => Assets.images.misc.emptyNft,
    };
  }

  AssetGenImage get bottomActionAsset {
    return switch (this) {
      WalletTabType.coins => Assets.images.icons.iconButtonManagecoin,
      WalletTabType.nfts => Assets.images.icons.iconButtonWalletnft,
    };
  }

  String getEmptyListTitle(BuildContext context) {
    return switch (this) {
      WalletTabType.coins => context.i18n.wallet_empty_coins,
      WalletTabType.nfts => context.i18n.wallet_empty_nfts,
    };
  }

  String getBottomActionTitle(BuildContext context) {
    return switch (this) {
      WalletTabType.coins => context.i18n.wallet_manage_coins,
      WalletTabType.nfts => context.i18n.wallet_buy_nfts,
    };
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case WalletTabType.coins:
        return context.i18n.core_coins;
      case WalletTabType.nfts:
        return context.i18n.core_nfts;
    }
  }
}
