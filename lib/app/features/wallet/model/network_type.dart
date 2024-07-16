import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/generated/assets.gen.dart';

enum NetworkType {
  all,
  arbitrum,
  eth,
  tron,
  matic,
  solana;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      NetworkType.all => context.i18n.core_all,
      NetworkType.arbitrum => 'Arbitrum One',
      NetworkType.eth => 'Ethereum',
      NetworkType.tron => 'Tron',
      NetworkType.matic => 'Polygon',
      NetworkType.solana => 'Solana',
    };
  }

  AssetGenImage get iconAsset {
    return switch (this) {
      NetworkType.all => Assets.images.wallet.walletInfinite,
      NetworkType.arbitrum => Assets.images.wallet.walletArbitrum,
      NetworkType.eth => Assets.images.wallet.walletEth,
      NetworkType.tron => Assets.images.wallet.walletTron,
      NetworkType.matic => Assets.images.wallet.walletMatic,
      NetworkType.solana => Assets.images.wallet.walletSolana,
    };
  }
}
