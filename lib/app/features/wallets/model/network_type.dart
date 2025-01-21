// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum NetworkType {
  all,
  arbitrum,
  bnb,
  cosmos,
  eth,
  tron,
  matic,
  solana;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      NetworkType.all => context.i18n.all_chains_item,
      NetworkType.arbitrum => 'Arbitrum',
      NetworkType.bnb => 'BNB Smart Chain',
      NetworkType.cosmos => 'Cosmos',
      NetworkType.eth => 'Ethereum',
      NetworkType.tron => 'Tron',
      NetworkType.matic => 'Polygon',
      NetworkType.solana => 'Solana',
    };
  }

  AssetGenImage get iconAsset {
    return switch (this) {
      NetworkType.all => Assets.images.wallet.walletAllnetwork,
      NetworkType.arbitrum => Assets.images.wallet.walletArbitrum,
      NetworkType.bnb => Assets.images.wallet.walletBinance,
      NetworkType.cosmos => Assets.images.wallet.walletCosmos,
      NetworkType.eth => Assets.images.wallet.walletEth,
      NetworkType.tron => Assets.images.wallet.walletTron,
      NetworkType.matic => Assets.images.wallet.walletMatic,
      NetworkType.solana => Assets.images.wallet.walletSolana,
    };
  }
}
