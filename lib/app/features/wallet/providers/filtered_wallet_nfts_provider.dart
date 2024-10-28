// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/nft_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_nfts_provider.g.dart';

@riverpod
Future<List<NftData>> filteredWalletNfts(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);
  final nftsState = ref.watch(filteredNftsProvider);

  final walletNfts = nftsState.valueOrNull ?? <NftData>[];

  return isZeroValueAssetsVisible
      ? walletNfts
      : walletNfts.where((NftData nft) => nft.price > 0.00).toList();
}
