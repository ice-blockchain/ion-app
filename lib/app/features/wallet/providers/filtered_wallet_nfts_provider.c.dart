// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallet/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_nfts_provider.c.g.dart';

@riverpod
Future<List<NftData>> filteredWalletNfts(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);
  final nftsState = ref.watch(filteredNftsProvider);

  final walletNfts = nftsState.valueOrNull ??
      <NftData>[
        NftData(
          collectionName: 'collectionName',
          identifier: 1,
          price: 100.1,
          currency: 'USD',
          iconUrl: Assets.images.notifications.avatar1.path,
          currencyIconUrl: Assets.images.notifications.avatar1.path,
          description: 'description',
          network: 'network',
          tokenStandard: 'tokenStandard',
          contractAddress: 'contractAddress',
          rank: 1,
          asset: Assets.images.notifications.avatar1.path,
        ),
      ];

  return isZeroValueAssetsVisible
      ? walletNfts
      : walletNfts.where((NftData nft) => nft.price > 0.00).toList();
}
