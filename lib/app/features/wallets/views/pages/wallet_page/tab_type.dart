// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/wallets/model/wallet_data_with_loading_state.c.dart';
import 'package:ion/generated/assets.gen.dart';

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
      WalletTabType.coins => Assets.svgWalletIconWalletEmptycoins,
      WalletTabType.nfts => Assets.svgCategoriesNft,
    };
  }

  String get bottomActionAsset {
    return switch (this) {
      WalletTabType.coins => Assets.svgIconButtonManagecoin,
      WalletTabType.nfts => Assets.svgIconButtonWalletnft,
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
