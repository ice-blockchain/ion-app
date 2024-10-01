// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/generated/assets.gen.dart';

enum WalletTabType {
  coins,
  nfts;

  WalletAssetType get walletAssetType {
    return switch (this) {
      WalletTabType.coins => WalletAssetType.coin,
      WalletTabType.nfts => WalletAssetType.nft,
    };
  }

  String get emptyListAsset {
    return switch (this) {
      WalletTabType.coins => Assets.svg.walletIconWalletEmptycoins,
      WalletTabType.nfts => Assets.svg.categoriesNft,
    };
  }

  String get bottomActionAsset {
    return switch (this) {
      WalletTabType.coins => Assets.svg.iconButtonManagecoin,
      WalletTabType.nfts => Assets.svg.iconButtonWalletnft,
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
